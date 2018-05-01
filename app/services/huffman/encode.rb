module Huffman
  class Encode < ::Callable
    def initialize(params = {})
      @content = params[:content]
    end

    def call
      Huffman::String.from_plaintext(content)
    end

    private

    attr_reader :content
  end
end