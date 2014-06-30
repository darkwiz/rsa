module RsaAttack

def rsa_attack (e, n)
    # Finds d from (e,n) thanks to the Wiener continued fraction attack

    frac = rational_to_contfrac(e, n)
    convergents = convergents_from_contfrac(frac)

    convergents.each do |conv|
      k = conv[0]
      d = conv[1]
      if k != 0 && (e*d-1) % k == 0
        phi = (e*d-1) / k
        b = n - phi +1
        discriminant = b*b - 4*n
        if discriminant >= 0
            t = false
            t = discriminant.isqrt if discriminant.perfect_square?
            if t && (b+t) % 2 == 0
                return d
            end
        end
      end

end

end
end
