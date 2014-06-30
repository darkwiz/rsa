module ContinuedFraction

def rational_to_contfrac (x, y)

#Converts a rational x/y fraction into
#a continued fraction represented with the list [a0, ..., an]

    a = x / y
    if a * y == x
        return [a]
    else
        cfraction = rational_to_contfrac(y, x - a * y)
        cfraction.insert(0, a)
        return cfraction
    end
end

def convergents_from_contfrac contfrac

 convs =[]
 contfrac.each_with_index do |e,i|
        convs  << contfrac_to_frac(contfrac[0..i])
end
convs
end


def contfrac_to_frac frac
    if frac.length == 0
        return 0, 1
    elsif frac.length == 1
        return frac[0], 1
    else
        remainders = frac[1..frac.length]
        num, denom = contfrac_to_frac(remainders)
        # fraction is now frac[0] + 1/(num/denom), which is
        # frac[0] + denom/num.
        return frac[0]*num + denom, num
    end
end

end


