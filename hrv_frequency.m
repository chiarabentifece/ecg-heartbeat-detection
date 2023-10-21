function [LF_BAND, HF_BAND, LF_HF_RATIO] = hrv_frequency(signal,fs)
% INPUT:
%   SIGNAL = Segnale preso in esame
%   FS = Frequenza di campionamento del segnale SIGNAL
% OUTPUT:
%   LF_BAND
%   HF_BAND
%   LF_HF_RATIO

% Nella frequenza calcolo:LF BAND, HF BAND, LF/HF:
signal_fft = fft(signal); % calcolo la fft del segnale 

LF_BAND = bandpower(signal_fft, fs, [0.04 0.15]);
HF_BAND = bandpower(signal_fft, fs, [0.15 0.4]);

% Calcolo LF/HF
LF_HF_RATIO = LF_BAND/HF_BAND;
end

