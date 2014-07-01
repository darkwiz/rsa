class Integer
   #MIller-Rabin Primality Test
   # http://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
   #
   # cf. http://betterexplained.com/articles/another-look-at-prime-numbers/ and
   # http://everything2.com/index.pl?node_id=1176369

   def prime?
     n = self.abs()
     return true if n == 2
     return false if n == 1 || n & 1 == 0

     return false if n > 3 && n % 6 != 1 && n % 6 != 5     # extra checks to improve the test speed cf. [0,1]
     d = n-1
     d >>= 1 while d & 1 == 0
     20.times do                               # 20 = k attempts
       a = rand(n-2) + 1                    # pick a base
       t = d
       y = mod_pow(a,t,n)
       while t != n-1 && y != 1 && y != n-1
         y = (y * y) % n
         t <<= 1
       end
       return false if y != n-1 && t & 1 == 0
     end
     return true
   end

   # Recursive version of gcd based on Euclidean algorithm

   def gcd n

   if self > n
      a = self
      b = n
    else
      a = n
      b= self
    end
      while a % b != 0
       b = b.gcd(a%b)
      end
    b
   end

# Use the extended Euclidean algorithm to compute modular inverse

   def mod_inverse m
      g= self.gcd(m)
      x, y = extended_gcd(self, m)
      if g != 1
        raise ArgumentError, 'Modular Inverse doesn t exist'
      else
        return x % m
      end
  end

  # Checks whether if an integer is a perfect square or not

   def perfect_square?

    h = self & 0xF  #Last Hexadecimal digit of input integer

    return false if h > 9

    if h != 2 && h != 3 && h != 5 && h != 6 && h != 7 && h != 8
        t = self.isqrt
          if t*t == self
            return true
          end
    else
      return false
    end
  end

  # Computes the square root for large nonegative integers
  # using a modified form of Newton's method for approximating roots

  def isqrt
    square = self.to_i
    return 0 if square == 0
    raise RangeError if square < 0

      # Actual computation
      n = iter(1, square) #Initial approximation
      n1 = iter(n, square) #Next approximation
      n1, n = iter(n1, square), n1 until n1 >= n - 1 #Continue calculation until desider accuracy
      n1 = n1 - 1 until n1*n1 <= square #Compensate error if the computed square  is gt square
    return n1
  end

private
  # Single iteration function
  def iter(n, square)
    (n+(square/n))/2
  end

end

