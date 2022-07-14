%Forklaring av funksjon:
%Utfoere konvolusjon mellom signal h[n] og x[n], tilsvare argument h og x.
%Argument ylen, tar i mot en int 0-1
function y = konvin3190 (h , x, ylen)
%Velge lengde av y, ved aa sender inn 0 eller 1 som tredje argument
% kan man velge mellom lengden til konvolusjonen
i = 0;
if ylen == 0 
    y = zeros(1,length(x));
elseif ylen == 1
    y = zeros(1,(length(h)+length(x)-1));
else
    disp("Feil argument: ylen")
    return;
end

%Utfoere konvolusjon
for n = 1:length(y)
    for k = 1:length(h)
        i=i+1;
        if (n-k+1) > 0 & (n-k+1) <= length(x)
            y(n) = y(n)+(h(k)*x(n-k+1));
    end
    end
i
end
