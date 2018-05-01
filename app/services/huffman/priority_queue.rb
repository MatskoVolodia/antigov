module Huffman
  class PriorityQueue
    delegate :length, to: :data
    delegate :delete, to: :data

    attr_accessor :data

    def initialize
      @data         = {}
      @data.default = 0
    end

    def put(k, v)
      data[k] = v
    end

    def get(k)
      data[k]
    end

    def peek
      unless length.zero?
        frequencies = data.sort_by{ |k, v| v }
        return frequencies.select{ |x| x[1] == frequencies[0][1] }
          .map(&:first)
          .sort_by(&:to_s)
          .first
      end
    end

    def peek_with_priority
      unless length.zero?
        value = peek
        [value, get(value)]
      end
    end

    def pop
      value = peek

      delete(value) unless value.nil?

      value
    end

    def pop_with_priority
      val = peek_with_priority

      return nil if val.nil?

      delete(val[0])

      val
    end
  end
end