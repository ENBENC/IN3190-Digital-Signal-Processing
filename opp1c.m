clc;
f1 = 10; f2 = 20; fs = 100; t_lengde = 5;
%t_lengde = T*n = n/fs => t*fs = n
n = 0:(t_lengde*fs);

%Signal x, y, h
x = sin(((2*pi*f1)/fs).* n) + sin(((2*pi*f2)/fs).* n);
h = (1/5)*(delta(n,0)+delta(n,1)+delta(n,2)+delta(n,3)+delta(n,4));
y = konvin3190(h,x,1);

%Frekvensspekkteret X,Y
[X,f_x] = Frekspekin3190(x,(t_lengde*fs),fs);
[Y,f_y] = Frekspekin3190(y,(t_lengde*fs),fs);
[H,f_h] = Frekspekin3190(h,(t_lengde*fs),fs);

tiledlayout(2,1);
ax1 = nexttile;
plot(ax1,f_h,abs(H));
xlabel('Frequency(Hz)');
ylabel('Magnitude of |H(e^jw)|');

ax2=nexttile;
hold on;
plot(ax2,f_x,abs(X));
plot(ax2,f_y,abs(Y));
xlabel('Frequency(Hz)');
ylabel('Magnitude of |Y(e^jw)| and |X(e^jw)|');
legend('X','Y');
hold off;

%H = Y/X, saa ved 20hz,40hz,60,hz er system responsen minst, og Y er
%veldig smaa mens X er veldig stor.

%Ved 0hz er system responsen stoerst, og Y/X ca 1.









