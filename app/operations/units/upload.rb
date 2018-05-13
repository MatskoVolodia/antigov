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

      {
        unit: unit,
        key:  private_key
      }
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
      chunks << Chunk.new(
        unit: unit,
        encoded: to_base32(encrypted(chunk[:result])),
        order: chunk[:order]
      )
    end

    def update_unit
      Chunk.import(chunks)
      unit.update(status: :uploaded)
    end

    def chunk_size
      @chunks_size ||= [500, content.length].min
    end

    def chunks
      @chunks ||= []
    end

    def encrypted(text)
      RSA::Encrypt.call(value: text, private_key: keys[:private_enc])
    end

    def keys
      @keys ||= RSA::KeyGenerator.call
    end

    def private_key
      @private_key ||= Base64.encode64(
        "#{unit.id}_#{keys[:private_dec].to_s}"
      )
    end

    def to_base32(number)
      number.to_i.to_s(32)
    end
  end
end