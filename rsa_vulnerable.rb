#This module generates RSA-keys which are vulnerable to
#the Wiener continued fraction attack this happens when d < (n^(1/4))/3

module RsaVulnerable

def gen_v_primes (bits=512)
  # Generates a couple of primes p, q such that
  # q < p < 2q
  range = (bits+1..2*bits-3)

  q = create_random_prime(bits)
  p = create_random_prime(bits, range)
  return p, q
end

def gen_v_keys (bits=512)
  #  Generates a key pair
  #  public = (e,n)
  #  private = d
  #    such that n is nbits long
  # (e,n) is vulnerable to the Wiener Continued Fraction Attack

   p, q = gen_v_primes(bits / 2)

  n=p*q
  phi = (p-1)*(q-1)
  #generate a d such that:
  # (d,n) = 1
  # d<1/3n^(1/4) --> 81d^4 < n
    good_d = false
    while !good_d
       d = (0..bits/4).map{rand()>0.5 ? '1':'0'}.join.to_i(2)
        if d.gcd(phi) == 1 && 81*mod_pow(d, 4, n) < n
            good_d = true
        end
      end
      e = d.mod_inverse(phi)
      return e, n, d
end

end
