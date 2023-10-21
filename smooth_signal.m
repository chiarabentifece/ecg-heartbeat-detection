function smooth_signal(signal, fs, window_size,y_label,titolo)

    % DIVIDO IL SEGNALE IN EPOCHE

    epochs=buffer(signal,10*fs,0); % 0 sta per quanti secondi/campioni devono stare sia su un'epoca sia sull'altra(in comune)

    outlier_positions = [];
    
    figure
    hold on

    mediana = median(abs(fft(signal)));

    % ottengo una matrice 8000x19=> 19 sono le epoche
    % CALCOLO FFT PER OGNI EPOCA
    for i=1:size(epochs,2)%scorre tutte le colonne

        epochs_fft= fft(epochs(:,i));
        epochs_fft= epochs_fft(1:(length(epochs_fft)/2) +1);
        
        % APPLICO IL MOVING AVERAGE FILTER PER OGNI EPOCA
        epochs_fft = movmean(epochs_fft,window_size);

        % Salvo l'epoca calcolata e filtrata in smoothed_epochs_fft(:,i)
        smoothed_epochs_fft(:,i) = epochs_fft;

        % calcolo la mediana delle epoche. median(matrice) mi restituisce
        % un vettore 1xcolonne, in cui ogni elemento è la mediana di quella
        % colonna.
        % per trovare la mediana, devo fare la mediana delle mediane
       
        
        if isempty(find(abs(smoothed_epochs_fft(:,i)) > (1.25 * mediana)))
             plot(abs(smoothed_epochs_fft(:,i)), 'k');
        else
            % non empty, ho trovato elementi che superano il 125% della
            % mediana
            outlier_positions(end+1) = i;
            plot(abs(smoothed_epochs_fft(:,i)), 'r');
            xlabel('frequenza [Hz]')
            ylabel(y_label)
            title(titolo)
            mediana = median(abs(reshape(fft(smoothed_epochs_fft), [], 1)));
       end
        
        
    end

    figure,
    hold on
    start = 1;
    stop = window_size* fs;
    for k=1:size(epochs,2)
        if ismember(k,outlier_positions)
            plot((start:stop), epochs(:,k), 'r');
        else
            plot((start:stop), epochs(:,k), 'k');
            xlabel('tempo [s]')
            ylabel(y_label)
            title(titolo)
        end
        start = start + window_size * fs;
        stop = stop + window_size * fs;
    end

    
  
end

