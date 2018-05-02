module Units
  class Upload < ::Callable
    CHUNK_SIZE = 500

    def initialize(params = {})
      @file_params = params[:file_params]
    end

    def call
      unit

      Thread.new {
        threads = []
        result = []

        chunked_content.each_with_index do |chunk, index|
          threads << Thread.new do
            result << { encoded: encode(chunk), order: index }
          end
        end

        threads.each { |thr| thr.join }

        result.sort_by { |k| k[:order] }.reduce('', &method(:join_chunks)).tap do |joined|
          unit.update(encoded: joined, status: :uploaded)
        end
      }
    end

    private

    attr_reader :file_params
    attr_accessor :unit

    def chunked_content
      @chunked_content ||= content.split('')
                             .each_slice(CHUNK_SIZE)
                             .to_a
                             .map(&:join)
    end

    def content
      @content ||= file_params[:file]&.read
    end

    def title
      @title ||= file_params[:file]&.original_filename
    end

    def encode(chunk)
      Huffman::Encode.call(content: chunk).to_s
    end

    def unit
      @unit ||= Unit.create(title: title)
    end

    def join_chunks(previous, current)
      "#{previous}#{current[:encoded]}"
    end
  end
end