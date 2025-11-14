function feats = mfcc_per_cycle(xc, fs, pars)
    if nargin < 3
        pars.frame_ms = 25; pars.hop_ms = 10;
        pars.n_mels = 26;   pars.n_mfcc = 13;
    end
    % Framing
    frame_len = round(pars.frame_ms*1e-3*fs);
    hop_len   = round(pars.hop_ms*1e-3*fs);
    nfft      = 2^nextpow2(frame_len);
    win       = hamming(frame_len, 'periodic');

    if exist('mfcc','file') == 2 % Usar Audio Toolbox si está disponible
        [C, ~] = mfcc(xc, fs, 'WindowLength', frame_len, 'OverlapLength', frame_len-hop_len, ...
                                'NumCoeffs', pars.n_mfcc, 'LogEnergy', 'Ignore');
        mu  = mean(C, 1, 'omitnan');
        sig = std(C,  0, 1, 'omitnan');
        feats = [mu sig];
        feats(isnan(feats)) = 0; % Corregir NaNs de std si el ciclo es muy corto
        return;
    end

    % Fallback manual (Requiere Signal Processing Toolbox)
    H     = melFilterBank(pars.n_mels, nfft, fs, 0, fs/2);
    nF    = max(0, 1 + floor((length(xc)-frame_len)/hop_len));
    if nF==0
        xc = [xc; zeros(max(0,frame_len-length(xc)),1)];
        nF = 1;
    end
    C = zeros(nF, pars.n_mfcc);
    idx = 1;
    for m = 1:nF
        seg = xc(idx:min(idx+frame_len-1, length(xc)));
        if length(seg)<frame_len, seg(end+1:frame_len)=0; end
        idx = idx + hop_len;

        X  = fft(seg.*win, nfft);
        P  = (abs(X(1:floor(nfft/2)+1)).^2) / frame_len;
        Em = H * P(:);
        Lm = log(Em + eps);

        D  = dctmtx(pars.n_mels); % Requiere Signal Processing Toolbox
        c  = D(1:pars.n_mfcc,:) * Lm(:);
        C(m,:) = c(:).';
    end

    mu  = mean(C, 1, 'omitnan');
    sig = std(C,  0, 1, 'omitnan');
    feats = [mu sig];
    feats(isnan(feats)) = 0; % Corregir NaNs
end