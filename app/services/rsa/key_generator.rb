module RSA
  class KeyGenerator < ::Callable
    SERVER_KEY = 8595431517640407292645935890959199917471211616445025379705341641499905883312466079517878672586858130662348331850631026517565012155291134918045134662276099

    def call
      {
        public:      user_key * SERVER_KEY,
        private_dec: mod_inverse(euler, lcm(user_key - 1, SERVER_KEY - 1)),
        private_enc: euler
      }
    end

    private

    attr_accessor :n, :euler, :d

    def euler
      @euler ||= coprime(lcm(user_key - 1, SERVER_KEY - 1))
    end

    def coprime(number)
      (2..number).find { |n| coprime?(n, number) }
    end

    def coprime?(a, b)
      (2..[a, b].min).select { |d| (a % d).zero? && (b % d).zero? }.empty?
    end

    def extended_gcd(a, b)
      last_remainder = a.abs
      remainder      = b.abs

      x, last_x, y, last_y = 0, 1, 1, 0

      while remainder != 0
        last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
        x, last_x = last_x - quotient*x, x
        y, last_y = last_y - quotient*y, y
      end

      return last_remainder, last_x * (a < 0 ? -1 : 1)
    end

    def gcd(a, b)
      b == 0 ? a : gcd(b, a.modulo(b))
    end

    def lcm(a, b)
      (a * b).abs / gcd(a, b)
    end

    def mod_inverse(e, et)
      g, x = extended_gcd(e, et)
      raise Exception if g != 1
      x % et
    end

    def user_key
      @user_key ||= OpenSSL::BN::generate_prime(512).to_i
    end
  end
end
