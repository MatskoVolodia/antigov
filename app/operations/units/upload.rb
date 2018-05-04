module Units
  class Upload < ::Callable
    CHUNK_SIZE = 500

    def initialize(params = {})
      @file_params = params[:file_params]
    end

    def call
      unit

      load_constants

      Chunker.call(
        chunked_content: chunked_content,
        single_handler:  :encode,
        reducer:         :join_chunks,
        final_handler:   :update_unit,
        object:          self,
        parallel:        true
      )
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
      "#{previous}/#{current}"
    end

    def load_constants
      Huffman::Tree
      Huffman::Node
      Huffman::String
      Huffman::Encode
      Huffman::Decode
      Huffman::PriorityQueue
    end

    def update_unit(joined)
      unit.update(encoded: joined, status: :uploaded)
    end
  end
end