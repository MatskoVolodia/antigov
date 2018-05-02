module Huffman
  class String
    attr_accessor :plaintext
    attr_accessor :tree
    attr_accessor :ciphertext

    def initialize(params = {})
      @plaintext  = params[:plaintext]
      @ciphertext = params[:ciphertext]
      @tree       = params[:tree]
    end

    def self.from_plaintext(text = '')
      Huffman::String.new.tap { |hs| hs.plaintext = text }
    end

    def self.from_ciphertext(ciphertext = '')
      Huffman::String.new.tap { |hs| hs.ciphertext = ciphertext }
    end

    def plaintext=(text)
      @plaintext  = text
      @tree       = Huffman::Tree.build(plaintext)
      @ciphertext = tree.encode(plaintext)
    end

    def ciphertext=(text)
      @tree, @ciphertext = Huffman::Tree.parse(text)
      @plaintext = tree.decode(ciphertext.clone)
    end

    def to_s
      "#{tree.to_binary_string}#{ciphertext}"
    end
  end
end