module Units
  class Upload < ::Callable
    include Constants

    def initialize(params = {})
      @file_params = params[:file_params]
    end

    def call
      unit

      load_constants

      Chunker.call(
        chunked_content: chunked_content,
        single_handler:  :encode,
        chunks_handler:  :create_chunks,
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
                             .each_slice(chunk_size)
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

    def create_chunks(chunk)
      chunks << Chunk.new(unit: unit, encoded: chunk[:result], order: chunk[:order])
    end

    def update_unit
      puts "============== FINAL HANDLER #{unit.title}"
      Chunk.import(chunks)
      unit.update(status: :uploaded)
    end

    def chunk_size
      @chunks_size ||= [1000, content.length].min
    end

    def chunks
      @chunks ||= []
    end
  end
end