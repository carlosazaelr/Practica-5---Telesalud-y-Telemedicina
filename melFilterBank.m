function H = melFilterBank(n_mels, nfft, fs, fmin, fmax)
    if nargin < 4, fmin = 0; end
    if nargin < 5, fmax = fs/2; end
    mels   = linspace(hz2mel(fmin), hz2mel(fmax), n_mels+2);
    hz     = mel2hz(mels);
    bins   = floor( (nfft+1) * hz / fs );
    H      = zeros(n_mels, floor(nfft/2)+1);
    for m = 1:n_mels
        fL=bins(m); fC=bins(m+1); fR=bins(m+2);
        for k = fL:fC
            if k>=0 && k<=floor(nfft/2)
                H(m,k+1) = (k-fL)/max(1,(fC-fL)); 
            end
        end
        for k = fC:fR
            if k>=0 && k<=floor(nfft/2)
                H(m,k+1) = (fR-k)/max(1,(fR-fC)); 
            end
        end
    end
end