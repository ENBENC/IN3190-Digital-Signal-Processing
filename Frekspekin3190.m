function [X,f] = frekspekin3190(x,N,fs)
%Denne funksjonen tar imot signal x, antall sample punkt N og
%samplefrekvens fs. Og renge frekvens response X og f som er tilhoerende frekvens til X.
%Argument: x(array), N(int), fs(int)
%Return: X(array, lengde N), f(int)

%anta at x er en kausal signal, slik sampling gaa fra 1 til N, matlab index
%begynner fra 1.
omega = linspace(-pi,pi, N);
X = zeros(1,N);
for n = 1:N
    w = omega(n);
    sum = 0;
    for k = 0:length(x)-1
        if k == 0
            sum = sum + (x(1)*exp(-j*w*k));
        else
            sum = sum + (x(k+1)*exp(-j*w*k));
            
        end
    end
    X(n) = sum;
end
%f er den unormalisert frekvensspekteret med fysisk frekvens i HZ
%f = normalisert frekvenssepkteret * fs
f = (1/(2*pi))*omega*fs;
end