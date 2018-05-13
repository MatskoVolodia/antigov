module RSA
  module Shared
    attr_accessor :value, :cipher, :public_key, :private_key, :alphabet, :alphabet_codepoints

    def initialize(params = {})
      @value  = params[:value]&.to_s&.downcase || []
      @cipher = params[:cipher] || []

      @private_key = params[:private_key]
      @public_key  = RSA::KeyGenerator::SERVER_KEY
    end

    def modular_pow(base, exponent, modulus)
      base.to_bn.mod_exp(exponent, modulus)
    end

    def alphabet_codepoints
      @alphabet_codepoints ||= alphabet.to_a.join.codepoints
    end

    def alphabet
      @alphabet ||= (0..1).map(&:to_s)
    end
  end
end