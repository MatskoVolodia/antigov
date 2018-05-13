module RSA
  class Encrypt < ::Callable
    include Shared

    def call
      value.split('').map { |v| v.codepoints.first }.each do |ind|
        @cipher << modular_pow(ind, private_key, public_key)
      end

      @cipher.join
    end
  end
end