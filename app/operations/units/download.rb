module Units
  class Download < ::Callable
    def initialize(params = {})
      @encoded = params[:encoded]
    end

    def call
      load_constants

      Chunker.call(
        chunked_content: chunked,
        single_handler:  :decode,
        reducer:         :join_chunks,
        final_handler:   :handle,
        object:          self
      )

      plaintext
    end

    private

    attr_accessor :encoded, :plaintext

    def decode(chunk)
      ::Huffman::Decode.call(content: chunk).plaintext
    end

    def chunked
      @chunked ||= encoded.split('/')
    end

    def handle(result)
      @plaintext = result
    end

    def join_chunks(previous, current)
      "#{previous}#{current}"
    end

    def load_constants
      Huffman::Tree
      Huffman::Node
      Huffman::String
      Huffman::Encode
      Huffman::Decode
      Huffman::PriorityQueue
    end
  end
end