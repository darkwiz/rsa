module ContinuedFraction

def rational_to_contf (x, y)

#Converts a rational x/y fraction into
#a continued fraction represented with the list [a0, ..., an]

    a = x / y
    if a * y == x
        return [a]
    else
        cfraction = rational_to_contf(y, x - a * y)
        cfraction.insert(0, a)
        return cfraction
    end
end

#computes the list of convergents from the continued fraction

def convergents_from_contfrac contfrac
 convs =[]
 contfrac.each_with_index do |e,i|
        convs  << contfrac_to_frac(contfrac[0..i])
end
convs
end

#Converts part of the continued fraction [a0, ..., ai]
# to an fraction n/d

def contfrac_to_frac frac

    if frac.length == 0
        return 0, 1
    elsif frac.length == 1
        return frac[0], 1
    else
        remainder = frac[1..frac.length]
        num, denom = contfrac_to_frac(remainder)
        # fraction is now frac[0] + 1/(num/denom), which is
        # frac[0] + denom/num.
        return frac[0]*num + denom, num
    end
end

end


