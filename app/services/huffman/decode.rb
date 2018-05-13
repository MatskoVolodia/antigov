module Huffman
  class Decode < ::Callable
    def initialize(params = {})
      @content = params[:content]
    end

    def call
      Huffman::String.from_ciphertext(content)
    end

    private

    attr_reader :content
  end
end