clear
close all
clc

% 1. Caricare il file .zip della cartella relativi ai dati e salvare i dati in una cartella apposita. Leggere 
% attentamente la documentazione nei file di testo presenti nella cartella dei dati. La documentazione 
% è necessaria per capire come sono stati raccolti i dati e come sono stati salvati

% Estraggo il contenuto dello zip nella cartella datasets

%unzip('data_Kaisti.zip','datasets');

% 3. Prendere in considerazione i dati ECG grezzi e i dati accelerometrici di due soggetti
% per ogni soggetto (file txt) i dati ECG sono nella prima colonna, mentre i dati accelerometrici sono nelle 2,3,4 colonne.
fs=800;

% carico i dati del primo soggetto
soggetto1 = readmatrix('datasets/sub_1.txt');
ecg_1 = soggetto1(:,1);
acc1 = soggetto1(:,2:4); % Ho messo tutte e 3 le componenti (x,y e z) sotto forma di un unica matrice
gyro1 = soggetto1(:,5:7);

% Tolgo la media
ecg_1 = ecg_1-mean(ecg_1);


% carico i dati del secondo soggetto
soggetto2 = readmatrix('datasets/sub_2.txt');
ecg_2 = soggetto2(:,1);
acc2 = soggetto2(:,2:4);
gyro2 = soggetto2(:,5:7);

% Tolgo la media
ecg_2 = ecg_2-mean(ecg_2);

% 4. Rappresentare i segnali grezzi di ciascun soggetto.

% Plotto i dati del primo soggetto
figure,
plot(ecg_1)
xlabel('campioni')
ylabel('mV')
title('ecg soggetto 1')

% Plotto i dati del secondo soggetto
figure,
plot(ecg_2)
xlabel('campioni')
ylabel('mV')
title('ecg soggetto 2')


% 5. Leggere il documento Filtering review.pdf, il file Kaisti.pdf e vedere di applicare due dei metodi tra 
% quelli indicati e quelli visti a lezione, per filtrare i dati ECG. Verificare l’effetto sul segnale ECG
% riportando il dato grezzo e il dato filtrato.

% Applico un filtro butterworth ai segnali ecg dei due soggetti.

% Tolgo sia il rumore che la respirazione, per il soggetto 1:
f_taglio1 = 0.5;
f_taglio2 = 50;

Wn1 = (f_taglio1*1)/(fs/2);
Wn2 = (f_taglio2*1)/(fs/2);

Wn = [Wn1 Wn2];
[B,A] = butter(3,Wn,'bandpass'); 

% Filtro il segnale ecg del soggetto 1 (butterworth)
ecg_1_butter = filtfilt(B,A,ecg_1);

% Filtro il segnale ecg del soggetto 2 (butterworth)
ecg_2_butter = filtfilt(B,A,ecg_2);

% Plotto sia il segnale filtrato che non filtrato per vedere le differenze
figure
hold on
plot(ecg_1, 'k');
plot(ecg_1_butter, 'r');
xlabel('campioni')
ylabel('mV')
title('segnale ECG soggetto: 1')

figure
hold on
plot(ecg_2, 'k');
plot(ecg_2_butter, 'r');
xlabel('campioni')
ylabel('mV')
title('segnale ECG soggetto: 2')

% Valuto un filtro ellittico sul segnale ecg

% Filtro con un altro filtro:ellip

% ellip(ordine, Rp (db), Rs (db), Wn, 'bandpass') 
[b,a] = ellip(3, 1, 80, Wn, 'bandpass');

% Filtro il segnale ecg con il filtro ellittico per il soggetto 1
ecg_1_ellip = filtfilt(b, a, ecg_1);

% Filtro il segnale ecg con il filtro ellittico per il soggetto 2
ecg_2_ellip = filtfilt(b, a, ecg_2);

figure,
hold on
plot(ecg_1,'k');
plot(ecg_1_butter,'m');
plot(ecg_1_ellip,'g');
xlabel('tempo [s]')
ylabel('ampiezza [mV]')
title('ecg soggetto 1')
legend({'ecg','ecg butterworth','ecg ellip'});

figure,
hold on
plot(ecg_2,'k');
plot(ecg_2_butter,'m');
plot(ecg_2_ellip,'g');
xlabel('tempo [s]')
ylabel('ampiezza [mV]')
title('ecg soggetto 2')
legend({'ecg','ecg butterworth','ecg ellip'});


% 6. Tracciare i dati accelerometrici e del giroscopio della prova esaminata. 
% Applicare il filtraggio indicato in Kaisti per quei tipi di dati.

% Plotto per ogni soggetto (1,2) le componenti separate di accellerometro e
% giroscopio

subplot_axis(acc1, '1'); % accellerometro soggetto 1
subplot_axis(gyro1, '1'); % giroscopio soggetto 1


% Sogg.2
subplot_axis(acc2, '2'); % accellerometro soggetto 2
subplot_axis(gyro2, '2'); % giroscopio soggetto 2


% Passiamo al filtraggio:Kaisti dice che prima bisogna trovare la
% componente migliore sia del gyro che dell'acc, e poi filtro solo quella
% attraverso un butterworth.

% andiamo a calcolare quali sono i migliori assi da prendere

best_pos_acc1 = best_axis(acc1, fs);
best_pos_gyro1 = best_axis(gyro1, fs);
best_pos_acc2 = best_axis(acc2, fs);
best_pos_gyro2 = best_axis(gyro2, fs);


% filtro il miglior segnale (Asse) con un filtro butterworth del terzo
% ordine con frequenze di cutoff di 0.5 e 20hz

% definisco il filtro butterworth
f_taglio1 = 0.5;
f_taglio2 = 20;

Wn1 = (f_taglio1*1)/(fs/2);
Wn2 = (f_taglio2*1)/(fs/2);

Wn = [Wn1 Wn2];
[B,A] = butter(3,Wn,'bandpass');

% vado a filtrare i migliori assi attraverso il filtro appena creato
% per filtrare l'asse, utilizzo segnale(:, best_pos), perchè ho bisogno di
% tutte le righe di una specifica colonna, che è stata calcolata tramite
% signal_quality

acc1_butter = filtfilt(B,A,acc1(:,best_pos_acc1));

gyro1_butter = filtfilt(B,A,gyro1(:,best_pos_gyro1));

acc2_butter = filtfilt(B,A,acc2(:,best_pos_acc2));

gyro2_butter = filtfilt(B,A,gyro2(:,best_pos_gyro2));


% dividere il segnale in epoche di 10 secondi,applico la fft single-sided
% per ogni epoca, agli spettri risultanti è applicato un moving average filter di 10 campioni 

smooth_signal(acc1_butter, fs, 10,'m/s^2','|Accelerometro| 1');
smooth_signal(gyro1_butter, fs, 10,'gradi','|Giroscopio|');
smooth_signal(acc2_butter, fs, 10,'m/s^2','|Accelerometro| 2');
smooth_signal(gyro2_butter, fs, 10,'gradi','|Giroscopio| 2');

% 7. Identificare i picchi con R sul segnale ECG con l’algoritmo visto a lezione con la Prof. Burattini. Salvare la sequenza dei picchi ottenuti in un array.
[qrs_amp_raw_ecg_1, qrs_i_raw_ecg_1, delay_ecg_1]=pan_tompkin(ecg_1_butter,fs,0);
%[qrs_amp_raw_ecg_2, qrs_i_raw_ecg_2, delay_ecg_2]=pan_tompkin(ecg_2_butter,fs,0);

%Metto da 2:end-1 per eliminare il primo e l'ultimo picco R:
% questo perchè se con il delta si va prima del primo picco e
% dopo l'ultimo picco, matlab dà errore
qrs_amp_raw_ecg_1= qrs_amp_raw_ecg_1(2:end-1); 
%qrs_amp_raw_ecg_2= qrs_amp_raw_ecg_2(2:end-1); 

R_ecg_1 =  qrs_i_raw_ecg_1 - round(delay_ecg_1/2);
%R_ecg_2 =  qrs_i_raw_ecg_2 - round(delay_ecg_2/2);

delta = 3;
R_corretto_ecg_1 = [];
%R_corretto_ecg_2 = [];

% Questo for lo uso dopo per i veri picchi R

for i= 1:length(R_ecg_1)

   [M,I]=max( ecg_1_butter(R_ecg_1(i)-delta : R_ecg_1(i)+delta) ); % M:ampiezza del max, I=indice del max 
   
   R_corretto_ecg_1 = [R_corretto_ecg_1, R_ecg_1-delta + I-1];

end

% for i= 1:length(R_ecg_2)
% 
%    [M,I]=max( ecg_2_butter(R_ecg_2(i)-delta : R_ecg_2(i)+delta) ); % M:ampiezza del max, I=indice del max 
%    
%    R_corretto_ecg_2 = [R_corretto_ecg_2, R_ecg_2-delta + I-1];
% 
% end

% Plotto ECG del soggetto 1 ed i picchi trovati dal metodo pan-tompkins

figure,
hold on
xlabel ('campioni')
ylabel ('ecg(mV)')
title ('Picchi R')

% Uso i picchi 
plot(ecg_1_butter)
plot(qrs_i_raw_ecg_1, ecg_1_butter(qrs_i_raw_ecg_1),'*')
plot(round(qrs_i_raw_ecg_1 - (delay_ecg_1/2)), ecg_1_butter(round(qrs_i_raw_ecg_1 - (delay_ecg_1/2))),'*') % Dopo che ho levato delay/2
legend({'ecg','posizione picchi dopo PT','posizione picchi - delay/2'});

% Adesso uso R_corretto 

figure,
plot(ecg_1_butter)
xlabel ('campioni')
ylabel ('ecg(mV)')
title ('Pan-Tompkin')
hold on
plot(R_corretto_ecg_1, ecg_1_butter(R_corretto_ecg_1),'x')
legend({'ecg','aggiustamento sul max picchi R'});

% Plotto ECG del soggetto 2 ed i picchi trovati dal metodo pan-tompkins

% figure,
% hold on
% xlabel ('campioni')
% ylabel ('ecg(mV)')
% title ('Picchi R')
% 
% % Uso i picchi 
% plot(ecg_2_butter)
% plot(qrs_i_raw_ecg_2, ecg_2_butter(qrs_i_raw_ecg_2),'*')
% plot(round(qrs_i_raw_ecg_2 - (delay_ecg_2/2)), ecg_2_butter(round(qrs_i_raw_ecg_2 - (delay_ecg_2/2))),'*') % Dopo che ho levato delay/2
% legend({'ecg','posizione picchi dopo PT','posizione picchi - delay/2'});
% 
% % Adesso uso R_corretto 
% 
% figure,
% plot(ecg_2_butter)
% xlabel ('campioni')
% ylabel ('ecg(mV)')
% title ('aggiustamento sul massimo picchi R in campioni')
% hold on
% plot(R_corretto_ecg_2, ecg_2_butter(R_corretto_ecg_2),'x')
% legenda = legend({'ecg','aggiustamento sul max picchi R'});


% 8. E possibile effettuare una valutazione automatica dei picchi R con un
% approccio in matlab differente?
% Provare a impostare la procedura e a verificare le differenze 
% con il metodo di riferimento.

% utilizzo la funzione di matlab findpeaks, che trova tutti i massimi
% locali
% la funzione mi restituisce: pks, array contenente le ampiezze dei picchi,
% locs che contiene gli indici (posizioni) in cui i picchi sono stati
% trovati
[pks,locs] = findpeaks(ecg_1_butter,'MinPeakHeight',2900);

% vado a stampare il segnale e tutti i picchi trovati 
figure
plot(ecg_1_butter)
hold on
plot(locs,ecg_1_butter(locs),'+')
xlabel('campioni')
ylabel('ecg(mV)')
title('Findpeaks')

% GIROSCOPIO 1
[pks_gyro_1,locs_gyro_1] = findpeaks(gyro1_butter,'MinPeakHeight',1000);

% vado a stampare il segnale e tutti i picchi trovati 
 figure
 plot(gyro1_butter, 'm')
 hold on
 plot(locs_gyro_1,gyro1_butter(locs_gyro_1),'+')
 title('find peaks gyro1')

% Per il soggetto 2:
[pks2,locs2] = findpeaks(ecg_2_butter,'MinPeakHeight',2000);
[pks_gyro_2,locs_gyro_2] = findpeaks(gyro2_butter,'MinPeakHeight',1000);
% vado a stampare il segnale e tutti i picchi trovati 
figure
plot(ecg_2_butter)
hold on
plot(locs2,ecg_2_butter(locs2),'+')
title('findpeaks sogg.2')

% 9. Calcolare gli intervalli tra battiti consecutivi,
% sulla base dei picchi individuati al punto precedente per i dati ottenuti
% dai due soggetti. Salvare i dati in due array.

% Per il soggetto 1:

for i = 2 : length(locs) 
   
    % nel primo posto di diff vado a mettere la distanza tra l'elemento 2 e
    % l'elemento 1 => faccio diviso fs e poi per mille per passare in
    % millisecondi

    RR_ecg_1(i-1) = (locs(i)/fs)*1000 - (locs(i-1)/fs)*1000; % diff avrà indici 1:169 (169 = length(qrs_i_raw) - 1)
   % e cosi via per ogni i (3-2, 4-3, 5-4 ecc) => posso farlo anche con la
   % funzione diff
end

for i = 2 : length(locs_gyro_1) 
   
    % nel primo posto di diff vado a mettere la distanza tra l'elemento 2 e
    % l'elemento 1 => faccio diviso fs e poi per mille per passare in
    % millisecondi

    RR_gyro_1(i-1) = (locs_gyro_1(i)/fs)*1000 - (locs_gyro_1(i-1)/fs)*1000; % diff avrà indici 1:169 (169 = length(qrs_i_raw) - 1)
   % e cosi via per ogni i (3-2, 4-3, 5-4 ecc) => posso farlo anche con la
   % funzione diff
end

% Per il soggetto 2:
for i = 2 : length(locs2) 
   
    % nel primo posto di diff vado a mettere la distanza tra l'elemento 2 e
    % l'elemento 1 => faccio diviso fs e poi per mille per passare in
    % millisecondi

    RR_ecg_2(i-1) = (locs2(i)/fs)*1000 - (locs2(i-1)/fs)*1000; % diff avrà indici 1:169 (169 = length(qrs_i_raw) - 1)

   % e cosi via per ogni i (3-2, 4-3, 5-4 ecc) => posso farlo anche con la
   % funzione diff
end

for i = 2 : length(locs_gyro_2) 
   
    % nel primo posto di diff vado a mettere la distanza tra l'elemento 2 e
    % l'elemento 1 => faccio diviso fs e poi per mille per passare in
    % millisecondi

    RR_gyro_2(i-1) = (locs_gyro_2(i)/fs)*1000 - (locs_gyro_2(i-1)/fs)*1000; % diff avrà indici 1:169 (169 = length(qrs_i_raw) - 1)
   % e cosi via per ogni i (3-2, 4-3, 5-4 ecc) => posso farlo anche con la
   % funzione diff
end

% 10. Rappresentare la nuova sequenza ottenuta su un diagramma in cui ogni elemento è l’intervallo intra-battito.

figure,
scatter(1:length(RR_ecg_1),RR_ecg_1)
ylabel('battiti')
xlabel('tempo[s]')
title('Intervalli RR ')
hold on
scatter(1:length(RR_ecg_2),RR_ecg_2) % Ho tutti soggetti sani

% Livello avanzato: Calcolare almeno 3 parametri per l’HRV nel dominio del tempo e altrettanti nel dominio della frequenza

% Nel dominio del tempo: SDNN, HRMAX-HRMIN, NN50, pNN50

% Soggetto 1
[SDNN_ECG_1, HR_MAX_MIN_ECG_1, NN50_ECG_1, PNN50_ECG_1] = hrv_time(RR_ecg_1); % ECG
[SDNN_GYRO_1, HR_MAX_MIN_GYRO_1, NN50_GYRO_1, PNN50_GYRO_1] = hrv_time(RR_gyro_1); % GIROSCOPIO

% Soggetto 2
[SDNN_ECG_2, HR_MAX_MIN_ECG_2, NN50_ECG_2, PNN50_ECG_2] = hrv_time(RR_ecg_2); % ECG
[SDNN_GYRO_2, HR_MAX_MIN_GYRO_2, NN50_GYRO_2, PNN50_GYRO_2] = hrv_time(RR_gyro_2); % GIROSCOPIO

% Nel dominio della frequenza: LF_BAND, HF_BAND, LF/HF

% Soggetto 1
[LF_BAND_ECG_1, HF_BAND_ECG_1, LF_HF_RATIO_ECG_1] = hrv_frequency(ecg_1_butter,fs); % ECG
[LF_BAND_GYRO_1, HF_BAND_GYRO_1, LF_HF_RATIO_GYRO_1] = hrv_frequency(gyro1_butter,fs); % GIROSCOPIO

% Soggetto 2
[LF_BAND_ECG_2, HF_BAND_ECG_2, LF_HF_RATIO_ECG_2] = hrv_frequency(ecg_2_butter,fs); % ECG
[LF_BAND_GYRO_2, HF_BAND_GYRO_2, LF_HF_RATIO_GYRO_2] = hrv_frequency(gyro2_butter,fs); % GIROSCOPIO

