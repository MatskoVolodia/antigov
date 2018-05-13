module RSA
  class Decrypt < ::Callable
    include Shared

    def call
      decrypted_numbers.each do |dec|
        @value << alphabet.to_a[alphabet_codepoints.index(dec)]
      end

      @value.join
    end

    def splitted
      cipher.split('').each_slice(6).map(&:join)
    end

    def decrypted_numbers
      splitted.map { |c| modular_pow(c.to_i, private_key.to_i, public_key) }
    end
  end
end