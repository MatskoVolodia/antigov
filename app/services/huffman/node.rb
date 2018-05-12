module Huffman
  class Node
    attr_accessor :left
    attr_accessor :right
    attr_accessor :parent
    attr_accessor :value

    def initialize(params = {})
      @left   = params[:left]
      @right  = params[:right]
      @parent = params[:parent]
      @value  = params[:value]
    end

    def to_s
      return value unless value.nil?

      unless left.nil? && right.nil?
        "#<Huffman::Node:value=#{value},left=#{left},right=#{right}>"
      end
    end

    def to_binary_string
      return "0#{left.to_binary_string}#{right.to_binary_string}" if value.nil?

      binary = value.bytes.to_a[0].to_s(2)

      "1#{("0" * (8 - binary.length) + binary)}"
    end

    def full_subtree?
      return !value.nil? if left.nil? && right.nil?

      left.full_subtree? && right.full_subtree?
    end
  end
end