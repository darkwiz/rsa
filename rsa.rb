require './integer'
require './continued_fractions'
require './rsa_vulnerable'
require './rsa_attack'

include ContinuedFraction   #Continued fractions module
include RsaVulnerable   #Vulnerable Key module
include RsaAttack #RSA Wiener low exponent attack

# Calculate a modular exponentiation eg: b^p mod m

def mod_pow(base, power, mod)
 result = 1
 while power > 0
   result = (result * base) % mod if power & 1 == 1
   base = (base * base) % mod
   power >>= 1;
 end
 result
end

# Make a random bignum of size bits, with the highest two and low bit set
# http://www.di-mgt.com.au/rsa_alg.html#note1

def create_random_bignum(bits, range = nil)
  if range.nil?
    middle = (1..bits-3).map{rand()>0.5 ? '1':'0'}.join
  else
    middle = (range).map { rand()>0.5 ? '1':'0' }.join
  end
  str = "11" + middle + "1"
  str.to_i(2)
end

# Create random numbers until it finds a prime

def create_random_prime(bits,range = nil)
  while true
    val = create_random_bignum(bits, range)
    return val if val.prime?
  end
end

# Do the extended euclidean algorithm: ax + by = gcd(a,b)

def extended_gcd(a, b)
  return [0,1] if a % b == 0
  x,y = extended_gcd(b, a % b)
  [y, x-y*(a / b)]
end

# Get d the modular multiplicative inverse of e mod(phi)
# thank to the extended euclidean algorithm
# a*x = 1 (mod m)

def get_d(p,q,e)
  phi = (p-1)*(q-1)
  x,y = extended_gcd(e,phi)
  x += phi if x<0 # Have to add the modulus if it returns negative
  x
end

# Convert a string into a big number
def str_to_bignum(s)
  n = 0
  s.each_byte{|b|n=n*256+b}
  n
end

# Convert a bignum to a string
def bignum_to_str(n)
  s=""
  while n>0
    s = (n&0xff).chr + s
    n >>= 8
  end
  s
end

 def rsa_attack_test
    puts "Testing Wiener Attack on RSA"

    3.times do
        e, n, d, p, q =gen_v_keys(1024)
        puts "(e,n) is ( %i , %i )" % [e, n]
        puts "\n d is : %i " % d
        puts "\r\n"
        puts "\n Created p is : %i, q is : %i " % [ p , q ]

        found_d, r1, r2= rsa_attack(e, n)

        if d == found_d
            puts "Attack Successful"
            puts "d = %i  \nfound_d = %i " % [ d, found_d ]
            puts "\r\n"
            puts "Factorized n: p= %i   q= %i " % [ r1 , r2 ]
        else
            puts  "Attack Fails..."
        end
        puts "-------------------------"
    end
end


# RSA test

#Generate two big primes: p and q
puts "Generating primes..."
p = create_random_prime(512)
q = create_random_prime(512)
 puts "Prime p:\r\n %i" % p
 puts "Prime q:\r\n %i" % q

# Make n now
n = p*q

# Public exponent
e = 0x10001   #decimal 65537 --> 2^16+1

# Private exponent
d = get_d(p,q,e)

puts "Public key (n,e):\r\n (%i, %i)" % [ n, e ]
puts "Private key (d):\r\n %x" % d

# Lets encrypt a message using e and n:
m = str_to_bignum("Hope it works!")
c = mod_pow(m,e,n) # Encrypting is: c = m^e mod n
puts "Message:\r\n " + bignum_to_str(m)
puts "Message hex:\r\n %x" % m
puts "Encrypted:\r\n %x" % c

# Now decrypt it using d and n:
a = mod_pow(c,d,n) # Decrypting is: m = c^d mod n
puts "Decrypted:\r\n " + bignum_to_str(a)

#RSA Attack test

rsa_attack_test

