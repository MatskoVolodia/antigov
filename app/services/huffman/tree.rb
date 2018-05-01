module Huffman
  class Tree
    attr_accessor :root

    delegate :to_binary_string, to: :root

    def initialize(root = nil)
      @root = root
    end

    def self.build(str = '')
      queue = Huffman::PriorityQueue.new

      str.split('').each { |c| queue.put(c, queue.get(c) + 1) }

      while queue.length > 1
        v1 = queue.pop_with_priority
        v2 = queue.pop_with_priority

        priority = v1[1] + v2[1]

        node = Huffman::Node.new

        if v1[0].is_a?(Huffman::Node)
          node.left = v1[0]
          node.left.parent = node
        else
          node.left = Huffman::Node.new(parent: node, value: v1[0])
        end

        if v2[0].is_a?(Huffman::Node)
          node.right = v2[0]
          node.right.parent = node
        else
          node.right = Huffman::Node.new(parent: node, value: v2[0])
        end

        queue.put(node, priority)
      end

      Huffman::Tree.new(queue.pop)
    end

    def self.parse(str)
      input   = str.clone
      root    = Huffman::Node.new
      current = root

      while true
        code = input.slice!(0, 1)

        case code
          when '0'
            current.left  = Huffman::Node.new
            current.right = Huffman::Node.new

            current.left.parent  = current
            current.right.parent = current

            current = current.left
          when '1'
            val = input.slice!(0, 8)
            current.value = Integer("0b#{val}").chr

            while current.present? && (current.right.nil? || current.right.full_subtree?)
              current = current.parent
            end

            break if current.nil? || (current == root && current.right.value.present?)

            current = current.right
        end
      end

      [Huffman::Tree.new(root), input]
    end

    def encode(text = '')
      text.split('').map{ |c| binary_path_to(c) }.join
    end

    def decode(ciphertext = '')
      current = root
      result  = ''

      while ciphertext.length.positive?
        val = ciphertext.slice!(0, 1)

        current = current.left  if val == '0'
        current = current.right if val == '1'

        if current.value.present?
          result += current.value
          current = root
        end
      end

      result
    end

    def to_s
      "#<Huffman::Tree:root=#{root}>"
    end

    def binary_path_to(char = '')
      answer  = []
      visited = {}
      current = self.root

      return '' if char.length != 1 || current.nil?

      while true
        visited[current] = true

        break if current.value == char

        if current.left.present? && current.left.is_a?(Huffman::Node) && !visited[current.left]
          answer << 0
          current = current.left
          next
        end

        if current.right.present? && current.right.is_a?(Huffman::Node) && !visited[current.right]
          answer << 1
          current = current.right
          next
        end

        if (current.right.nil? || visited[current.right]) && (current.left.nil? || visited[current.left])
          answer.pop
          current = current.parent
          next
        end

        break
      end

      answer.map(&:to_s).join
    end
  end
end