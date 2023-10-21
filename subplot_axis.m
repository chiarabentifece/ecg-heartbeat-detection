function subplot_axis(signal, subject)
% signal = segnale da plottare
% subject = intero, serve solo nel title per indicare il soggetto plottato

figure,
subplot(3,1,1)
plot(signal(:,1))
title(strcat('componente x del soggetto:', subject))

subplot(3,1,2)
plot(signal(:,2))
title(strcat('componente y del soggetto:', subject))

subplot(3,1,3)
plot(signal(:,3))
title(strcat('componente z del soggetto:', subject))
end

