module Huffman
  class Decode < ::Callable
    def initialize(params = {})
      @content = params[:content]
    end

    def call
      Huffman::String.from_ciphertext(content)
      #
      # content.split('/').map do |c|
      #   Huffman::String.from_ciphertext(c)
      # end.join
    end

    private

    attr_reader :content
  end
end