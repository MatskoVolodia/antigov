module Units
  class Download < ::Callable
    include Constants

    def initialize(params = {})
      @unit = params[:unit]
      @key  = params[:key]
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

    attr_accessor :unit, :plaintext, :key

    def decode(chunk)
      ::Huffman::Decode.call(content: chunk).plaintext
    end

    def chunked
      @chunked ||= unit.chunks.sort_by(&:order)
        .map(&:encoded)
        .map(&method(:from_base32))
        .map(&method(:decrypted))
    end

    def handle
      @plaintext = chunks.sort_by { |k| k[:order] }
        .map { |h| h[:result] }
        .join
    end

    def add_chunks(chunk)
      chunks << chunk
    end

    def decrypted(text)
      RSA::Decrypt.call(cipher: text, private_key: key)
    end

    def chunks
      @chunks ||= []
    end

    def from_base32(number)
      number.to_i(32).to_s
    end
  end
end