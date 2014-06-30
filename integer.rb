class Integer
   def prime?
     n = self.abs()
     return true if n == 2
     return false if n == 1 || n & 1 == 0
     # cf. http://betterexplained.com/articles/another-look-at-prime-numbers/ and
     # http://everything2.com/index.pl?node_id=1176369
     return false if n > 3 && n % 6 != 1 && n % 6 != 5     # added
     d = n-1
     d >>= 1 while d & 1 == 0
     20.times do                               # 20 = k from above
       a = rand(n-2) + 1
       t = d
       y = mod_pow(a,t,n)                  # implemented below
       while t != n-1 && y != 1 && y != n-1
         y = (y * y) % n
         t <<= 1
       end
       return false if y != n-1 && t & 1 == 0
     end
     return true
   end


   # def gcd n
   # My version of gcd based on Euclidean algorithm
   # if self > n
   #    a = self
   #    b = n
   #  else
   #    a = n
   #    b= self
   #  end
   #    while a % b != 0
   #     b = b.gcd(a%b)
   #    end
   #  b
   # end

   def mod_inverse m
    # Use the extended Euclidean algorithm to compute modular inverse
      g= self.gcd(m)
      x, y = extended_gcd(self, m)
      if g != 1
        raise ArgumentError, 'Modular Inverse doesn t exist'
      else
        return x % m
      end
  end



   def perfect_square?

    # Checks whether if an integer is a perfect square or not

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

  def isqrt
    # Computes the square root for large nonegative integers

    square = self.to_i
    return 0 if square == 0
    raise RangeError if square < 0

      # Actual computation
      n = iter(1, square)
      n1 = iter(n, square)
      n1, n = iter(n1, square), n1 until n1 >= n - 1
      n1 = n1 - 1 until n1*n1 <= square
    return n1
  end

private

  def iter(n, square)
    (n+(square/n))/2
  end

end

