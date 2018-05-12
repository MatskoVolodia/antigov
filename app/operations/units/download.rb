module Units
  class Download < ::Callable
    include Constants

    def initialize(params = {})
      @unit = params[:unit]
    end

    def call
      load_constants

      Chunker.call(
        chunked_content: chunked,
        single_handler:  :decode,
        chunks_handler:  :add_chunks,
        final_handler:   :handle,
        object:          self
      )

      sleep(1) until plaintext

      plaintext
    end

    private

    attr_accessor :unit, :plaintext

    def decode(chunk)
      ::Huffman::Decode.call(content: chunk).plaintext
    end

    def chunked
      @chunked ||= unit.chunks.sort_by(&:order).map(&:encoded)
    end

    def handle
      @plaintext = chunks.sort_by { |k| k[:order] }
                         .map { |h| h[:result] }
                         .join
    end

    def add_chunks(chunk)
      chunks << chunk
    end

    def chunks
      @chunks ||= []
    end
  end
end