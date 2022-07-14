function d = delta(n,x)
%Dette funksjon ta imot en n vector og en integer x
%Return en vektor paa lengde n, der d(x+1) er 1 og resten er 0.
d = zeros(1,length(n));
%siden matlab har array index fra 1 dermed maa vi gjoere en variabel skift.
d(x+1) = 1;
end