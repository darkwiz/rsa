module RsaAttack

# Finds d from (e,n) thanks to the Wiener continued fraction attack

def rsa_attack (e, n)

    frac = rational_to_contf(e, n)
    convergents = convergents_from_contfrac(frac)

    convergents.each do |conv|
      k = conv[0]
      d = conv[1]

      if k != 0 && (e*d-1) % k == 0   # check if C, candidate for phi is actually the key
        phi = (e*d-1) / k
        b = n - phi +1
        discriminant = b*b - 4*n  # check if the equation x^2+ s*x + n = 0
        if discriminant >= 0        # has integer root
            t = false
            t = discriminant.isqrt if discriminant.perfect_square?
            if t && (b+t) % 2 == 0
                if discriminant > 0
                   r1, r2 = roots(t,b,n)
                end
                return d, r1, r2
            end
        end
      end
    end
end

# finds the roots of the equation x^2+ s*x + n = 0
# which solutions are possibly the factorization of n

def roots (t,b, n)
  r1 = (- b + t ) / 2
  r2 = ( -b - t ) / 2
  return r1.abs , r2.abs
end

end
