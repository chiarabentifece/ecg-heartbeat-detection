function signal_quality = signal_quality(signal, fs)
     % Questa funzione va a calcolare il rapporto tra peak2peak del segnale
     % e la mad (median average deviation) del rumore
     % applica un filtro butterworth del terzo ordine

     f_taglio = 50;

     Wn = (f_taglio*1)/(fs/2);

     % uso un filtro passa alto a 50hz perchè mi interessa tenere solo il rumore
     [B,A] = butter(3,Wn,'high');

     % noise contiene solo rumore, la parte informativa è stata scartata dal filtro
     noise = filtfilt(B,A,signal); % Isolo il rumore

     signal_quality = peak2peak(signal) / mad(noise);

end

