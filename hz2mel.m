function m = hz2mel(hz)
    m = 2595*log10(1+hz/700); 
end