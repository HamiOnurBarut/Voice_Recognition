function x = twos2dec(t) %2s complement function for signed data
    %error(nargchk(1,1,nargin));
    if iscellstr(t)
        t = char(t);
    end
    x = bin2dec(t);
    nbits = sum(t == '0' | t == '1', 2);
    xneg = log2(x) >= nbits - 1;
    if any(xneg)
        x(xneg) = -( bitcmp(x(xneg), 'uint8') + 1 );
    end
end