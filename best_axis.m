function best_axes = best_axis(signal, fs)
% questa funzione restituisce un numero intero (1,2,3) che corrisponde al
% migliore asse da considerare (utilizzando signal_quality).
% l'asse è espresso come numero (1,2,3), poichè il numero corrisponde alla
% posizione nel segnale dell'asse (x = 1, y = 2, z = 3).

% prealloco un vettore 3x1 con tutti 0
signal_axes = zeros(3,1);

for i=1:3
    % per ogni asse (i), vado a calcolare la signal_quality di quell'asse e
    % lo memorizzo al posto i-esimo.
    signal_axes(i) = signal_quality(signal(:,i), fs);
end

% all'interno del vettore signal_axes ho 3 "punteggi" che rappresentano la
% qualità del segnale. Più è alto il punteggio, maggiore è la sua qualità

% Poichè mi interessa soltanto l'asse (e non il suo punteggio), la funzione
% max memorizza l'asse migliore nella variabile best_axes e lo restituisce
[score, best_axes] = max(signal_axes);
end

