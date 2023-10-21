function [SDNN, HR_MAX_MIN, NN50, PNN50] = hrv_time(RR)
% INPUT:
%   RR = Intervallo tra i picchi RR (ms)
% OUTPUT:
%   SDNN
%   HR_MAX_MIN
%   NN50
%   PNN50

% Nel dominio del tempo SDNN,HRMAX-HRMIN,NN50,pNN50
SDNN = std(RR);

% CONVERTO I MIEI PICCHI RR DA MILLISECONDI A SECONDI, E LI MEMORIZZO
% DENTRO RRS
RRS = 1000./RR;

% CALCOLO HEART RATE IN BPM (60 / RRS)
HEART_RATE = 60./RRS;

% TROVO IL MASSIMO ED IL MINIMO DI HEART RATE
HR_MAX = max(HEART_RATE);
HR_MIN = min(HEART_RATE); 

% CALCOLO LA DIFFERENZA TRA MAX HEART RATE E MIN HEART RATE
HR_MAX_MIN = HR_MAX - HR_MIN;

% inizializzo il contatore
NN50 = 0;

% VADO A CERCARE IN RR TUTTI I BATTITI CHE SONO DURATI PIU' DI 50ms
% MI FERMO A LENGTH(RR) - 1 PERCHE I BATTITI (INTERVALLI) SONO DATI DAI PICCHI RR - 1
for i = 1:length(RR)-1
    if abs(RR(i) - RR(i+1)) > 50
        NN50 = NN50 + 1;
    end
end

% CALCOLO LA PNN50, OSSIA NN50 IN PERCENTUALE
% x:100=nn50:totale(lengthRR)
PNN50 = (100*NN50)/(length(RR));

end
