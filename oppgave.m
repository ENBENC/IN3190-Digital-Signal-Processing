clear;
load bihuic.mat;
%% Oppgave2a
clear;
load bihuic.mat;
load data.mat;
h1 = [0.0002, 0.0001, -0.0001, -0.0005, -0.0011, -0.0017, -0.0019, ...
    -0.0016, -0.0005, 0.0015, 0.0040, 0.0064, 0.0079, 0.0075, 0.0046, ...
    -0.0009, -0.0084, -0.0164, -0.0227, -0.0248, -0.0203, -0.0079, ...
    0.0127, 0.0400, 0.0712, 0.1021, 0.1284, 0.1461, 0.1523, 0.1461, ...
    0.1284, 0.1021, 0.0712, 0.0400, 0.0127, -0.0079, -0.0203, -0.0248, ...
    -0.0227, -0.0164, -0.0084, -0.0009, 0.0046, 0.0075, 0.0079, 0.0064, ...
    0.0040, 0.0015, -0.0005, -0.0016, -0.0019, -0.0017, -0.0011, ...
    -0.0005, -0.0001, 0.0001, 0.0002];

h2 = [-0.0002, -0.0001, 0.0003, 0.0005, -0.0001, -0.0009, -0.0007, ...
    0.0007, 0.0018, 0.0005, -0.0021, -0.0027, 0.0004, 0.0042, 0.0031, ...
    -0.0028, -0.0067, -0.0023, 0.0069, 0.0091, -0.0010, -0.0127, ...
    -0.0100, 0.0077, 0.0198, 0.0075, -0.0193, -0.0272, 0.0014, 0.0386, ...
    0.0338, -0.0246, -0.0771, -0.0384, 0.1128, 0.2929, 0.3734, 0.2929, ...
    0.1128, -0.0384, -0.0771, -0.0246, 0.0338, 0.0386, 0.0014, -0.0272, ...
    -0.0193, 0.0075, 0.0198, 0.0077, -0.0100, -0.0127, -0.0010, 0.0091, ...
    0.0069, -0.0023, -0.0067, -0.0028, 0.0031, 0.0042, 0.0004, -0.0027, ...
    -0.0021, 0.0005, 0.0018, 0.0007, -0.0007, -0.0009, -0.0001, 0.0005, ...
    0.0003, -0.0001, -0.0002];
length(h1)
length(h2)

tiledlayout(2,1);
ax1 = nexttile;
hold on;
plot(ax1,h1);
plot(ax1,h2);
xlabel('n');
ylabel('Magnitude');
legend('h1','h2');
hold off;

ax2 = nexttile;
[H1,f_h1] = Frekspekin3190(h1,1000,2*pi);
[H2,f_h2] = Frekspekin3190(h2,1000,2*pi);
H1_db = 20*log10(abs(H1));
H2_db = 20*log10(abs(H2));
hold on;
plot(ax2,f_h1,H1_db);
plot(ax2,f_h2,H2_db);
xlabel('Frequency normalisert(rad)');
ylabel('Magnitude db');
legend('H1 db','H2 db');
hold off;

%Fra figuren ser vi at filter h1 har mindre passbound enn filter h2.
%Det vil si at noen hoeyre frekvens kan passere filter h2 men ikke h1.
%Men begge er lav pass filter, som passere frekvens som bare passere lave 
%frekvenser.

%Generelt, filter h1 slipper gjenneom lavere frekvens enn filter h2.

%% Oppgave2b
clear;
load bihuic.mat;
load data.mat;
%Offset fra 1- n
n = 5; fs = 250;
avstand = offset1;
x_uten = zeros(1501,n);
x_med = zeros(1501:n);
X_uten = zeros(1501,n);
X_med = zeros(1501:n);

for i = 1:n
x_utenVindu = seismogram1(:,i);
W = tukeywin(length(t),0.1);
x_medVindu = W.*seismogram1(:,i);

[X_utenVindu,f_x_uten] = Frekspekin3190(x_utenVindu,length(t)*fs,fs);
[X_medVindu,f_x_med] = Frekspekin3190(x_medVindu,length(t)*fs,fs);
X_utenVindu_db = 20*log10(abs(X_utenVindu));
X_medVindu_db = 20*log10(abs(X_medVindu));


x_uten(:,i) = x_utenVindu;
x_med(:,i) = x_medVindu;
X_uten(:,i) = X_utenVindu_db; 
X_med(:,i) = X_medVindu_db;
end

figure;
tiledlayout(2,1);
ax1 = nexttile;
hold on;
for i = 1:n
plot(ax1,100*x_uten(:,i)+offset1(i),t);
end
hold off;
xlabel('offset[m]');
ylabel('tid[s]');
legend('x utenVindu');

ax2 = nexttile;
hold on;
for i = 1:n
plot(ax2,100*x_med(:,i)+offset1(i),t);
end
hold off;
xlabel('offset[m]');
ylabel('tid[s]');
legend('x medVindu');

figure;
tiledlayout(2,1);
ax3 = nexttile;
plot(ax3,f_x_uten,X_uten);
xlabel('Frequency');
ylabel('Magnitude');
legend('X utenVindu db');

ax4 = nexttile;
plot(ax4,f_x_med,X_med);
xlabel('Frequency');
ylabel('Magnitude');
legend('X medVindu db');

%Siden hoeye frekvense vil absoberes av de dypere lagene. Dermed vil den
%hoeye frekvensene representere stoey.
%Fra frekvensspekteren ser delen til venstre og hoyere er stoey, mens delen
%mot midten er signal vi oensker. 

%% Oppgave 2c
clear;
load bihuic.mat;
load data.mat;
x = seismogram1;
y1_all = zeros(1501,601);
y2_all = zeros(1501,601);

%beregne y1 og y2 for alle signal i x
for i = 1:601
y1 = konvin3190 (h1 , x(:,i), 0);
y2 = konvin3190 (h2 , x(:,i), 0);

y1_all(:,i) = y1; 
y2_all(:,i) = y2; 

end


figure;
imagesc(offset1,t,y1_all,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('y1');

figure;
imagesc(offset1,t,y2_all,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('y2');


figure;
imagesc(offset1,t,x,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('x');


%{
figure;
for i = 1:length(offset1)
    hold on;
    plot(1000*y1_all(:,i)+offset1(i),t*1000,'Color','black')
    xlabel('meter[m]');
    ylabel('tid[ms]');
end
legend('y1');
hold off;

figure;
for i = 1:length(offset1)
    hold on;
    plot(1000*y2_all(:,i)+offset1(i),t*1000,'Color','black')
    xlabel('meter[m]');
    ylabel('tid[ms]');
end
legend('y2');
hold off;

figure;
for i = 1:length(offset1)
    hold on;
    plot(1000*x(:,i)+offset1(i),t*1000,'Color','black')
    xlabel('meter[m]');
    ylabel('tid[ms]');
end
legend('x');
hold off;
%}


 
%Viser at filter h1 fjerner mest stoey, dermed er h1 passer best til
%stoeyfjerning here, Siden h1 vil bare passere de minste frekvensene.
%h2 vil ogsaa passere lave frekvensene, det er gode til aa fjerne stoeyene,
%men ikke like bra som h1.

%% Oppgave 3a
clear;
load bihuic.mat;
load data.mat;
%vi trenger omraade, tid:0.6s-1s(rad 151-251), offset:1 (100m)
puls = y1_all(151:251,1);
tid = t(151:251);

[PULS,f_puls] = Frekspekin3190(puls,length(t),fs);
PULS_db = 20*log10(abs(PULS));

tiledlayout(2,1);
ax1 = nexttile;
plot(ax1,tid,puls);
xlabel('tid[s]');
ylabel('Magnitute');
title('Direkte ankomst')

ax2 = nexttile;
plot(ax2,f_puls,PULS_db);
xlabel('Frekvens[HZ]');
ylabel('Magnitute[db]');
title('PULS db')

%% Oppgave 3b
clear;
load bihuic.mat;
load data.mat;
%vi trenger omraade, tid:0.6s-1s(rad 151-251), offset:1 (100m)
x = y1_all(151:251,1:20);
tid = t(151:251);
lengde = length(tid);
%Offset fra 1- n
n = length(x(1,:));
x_uten = zeros(lengde,n);
x_med = zeros(lengde:n);
X_uten = zeros(lengde,n);
X_med = zeros(lengde:n);

for i = 1:n
x_utenVindu = x(:,i);
W = tukeywin(length(x_utenVindu),0.5);
x_medVindu = W.*x(:,i);

[X_utenVindu,f_x_uten] = Frekspekin3190(x_utenVindu,length(tid),fs);
[X_medVindu,f_x_med] = Frekspekin3190(x_medVindu,length(tid),fs);
X_utenVindu_db = 20*log10(abs(X_utenVindu));
X_medVindu_db = 20*log10(abs(X_medVindu));

X_uten(:,i) = X_utenVindu_db; 
X_med(:,i) = X_medVindu_db;
x_med(:,i) = x_medVindu;
x_uten(:,i) = x_utenVindu;
end

%plott puls med og uten vindu
figure;
plot(f_x_uten,X_uten);
title('X uten vindu db')
xlabel('Frequency(HZ)');
ylabel('Magnitude');

figure;
plot(f_x_med,X_med);
title('X med vindu db')
xlabel('Frequency(HZ)');
ylabel('Magnitude');
%dominate frekvensen er ca 14.67hz

%% Oppgave 4a
clear;
load bihuic.mat;
load data.mat;
x = y1_all;
x1 = y1_all(1:1501,1);
t1 = t(1:1501);

figure;
hold on;
plot(t1,x1);
index = 191;
plot(t(index),y1_all(index),'x','MarkerSize',10,'LineWidth',3)

for i = 1:3
index = index +191;
plot(t(index),y1_all(index),'o','MarkerSize',10,'LineWidth',3)
end 

xlabel('tid[s]');
ylabel('Magnitude');
hold off;

figure;
imagesc(offset1,t*1000,y1_all,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.001 0.001]);
xlabel('Offset[m]');
ylabel('Tid[ms]');
title('Gather med mark av refleksjon til 1.sediment?rlaget')

hold on;
index = 191;
plot(y1_all(1),1000*t(index),'x','MarkerSize',10,'LineWidth',3)
t(index)
for i = 1:3
index = index +191;
plot(y1_all(1),1000*t(index),'o','MarkerSize',10,'LineWidth',3);
t(index)
end 
hold off;


%tw = 0.76s, tiden det tar for foerste signalet til aa kommer tilbake
%% Oppgave 4b
clear;
load bihuic.mat;
load data.mat;
x = y1_all;
x1 = y1_all(1:1501,1);
t1 = t(1:1501);

figure;
hold on;
plot(t1,x1);
index = 641+180;
plot(t(641),y1_all(641),'x','MarkerSize',10,'LineWidth',3);
for i = 1:2
    plot(t(index),y1_all(index),'o','MarkerSize',10,'LineWidth',3)
    index = index +180;
end
xlabel('tid[s]');
ylabel('Magnitude');
hold off;

figure;
imagesc(offset1,t*1000,y1_all,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.001 0.001]);
xlabel('Offset[m]');
ylabel('Tid[ms]');
title('Gather med mark av refleksjon til 2.sediment?rlaget')

hold on;
plot(t1,x1);
index = 641+180;
plot(y1_all(1),1000*t(633),'x','MarkerSize',10,'LineWidth',3);
for i = 1:2
    plot(y1_all(1),1000*t(index),'o','MarkerSize',10,'LineWidth',3)
    index = index +180;
end
hold off;

%% Oppgave 5
clear;
load bihuic.mat;
load data.mat;
x_offset_1 = y1_all(1:200,11);
x_offset_2 = y1_all(1:200,61);
tid = t(1:200);

tiledlayout(2,1);
ax1 = nexttile;
plot(ax1,tid,abs(x_offset_1));
xlabel('tid[s]');
ylabel('Magnitude');
title('mik offset 11')

ax2 = nexttile;
plot(ax2,tid,abs(x_offset_2));
xlabel('tid[s]');
ylabel('Magnitude');
title('mik offset 61')
% Vi finner lydhastighet i vann, ved aa sjekke tiden lyden tar mellom to
% mikrofon. Her saa bruke er avstand 100m og tiden der tar for boelgen til
% aa gaa over dette avstanden er ca 0.068s. Dette tilsvarer ca. 1470m/s
%% Oppgave6a
clear;
load bihuic.mat;
load data.mat;

corrected_seismic1 = nmocorrection2(t,0.0040,offset1,y1_all,1450);

corrected_seismic2 = nmocorrection2(t,0.0040,offset1,y1_all,1490);

corrected_seismic3 = nmocorrection2(t,0.0040,offset1,y1_all,1520);
figure;
imagesc(offset1,t*1000,corrected_seismic1,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('corrected_seismic1')

figure;
imagesc(offset1,t*1000,corrected_seismic2,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('corrected_seismic2')

figure;
imagesc(offset1,t*1000,corrected_seismic3,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.01 0.01]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('corrected_seismic3')
%% Oppgave6a
clear;
load bihuic.mat;
load data.mat;

corrected_seismic1 = nmocorrection2(t,0.0040,offset1,y1_all,2500);

figure;
imagesc(offset1,t*1000,corrected_seismic1,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.001 0.001]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('corrected_seismic1')

%% Oppgave 6b
clear;
load bihuic.mat;
load data.mat;

corrected_seismic1_water = nmocorrection2(t,0.0040,offset1,y1_all,1470);
corrected_seismic1_first_sedm = nmocorrection2(t,0.0040,offset1,y1_all,2600);
figure;
p = [corrected_seismic1_water(1:381,1:601);corrected_seismic1_first_sedm(382:1501,1:601)];

imagesc(offset1,t,p,[caxis]);

colormap gray;
cc = caxis();
caxis([-0.001 0.001]);
xlabel('Offset[m]');
ylabel('Tid[s]');
title('NMO-korrigerte gatheret,kons. hast. i vann-og seid.laget')

%% Oppgave 7a
clear;
load bihuic.mat;
load data.mat;
x_offset_1 = y1_all(501:751,500);
x_offset_2 = y1_all(501:751,560);
tid = t(251:501);

figure;
tiledlayout(2,1);
ax1 = nexttile;
plot(ax1,tid,(x_offset_1));
xlabel('tid[s]');
ylabel('Magnitude');
legend('mik offset 1')

ax2 = nexttile;
plot(ax2,tid,(x_offset_2));
xlabel('tid[s]');
ylabel('Magnitude');
legend('mik offset 2')
%% Oppgave 7b
clear;
load bihuic.mat;
load data.mat;

x_offset_1 = y1_all(901:1001,591);
x_offset_2 = y1_all(901:1001,601);
tid = t(901:1001);

figure;
hold on;
plot(tid,(x_offset_1));
plot(tid,(x_offset_2));
xlabel('tid[s]');
ylabel('Magnitude');
hold off;
%Over estamiere refraksjons hastighet til aa vare tilnaermet like
%til refleksjon hastighet til 2.sedimentaerlaget.
%Ved aa finne tangensen til plotten var hastigheten ca. 4000m/s. 
%Denne maaten aa finne paa har ganske stor unoeyaktighet.
%Ved aa plotte refleksjon i offset 591 til 601, der avstand er 100m.
%Og boelgen beveger seg over en tid som er 0.028s. 
%Dermed gir det en litt noeyaktigere estimering som er ca.3570m/s.
%Men dette er likeveld en grov overestimat av reflaksjons hastighet til 
%2.sedimentaerlaget. Den virkelige reflaksjonstiden boer vare lavere enn
%det. 

%% Opppgave7c
clear;
load bihuic.mat;
load data.mat;
x = seismogram2;
y11_all = zeros(1501,801);
y22_all = zeros(1501,801);

%beregne y1 og y2 for alle signal i x
for i = 1:801
y1 = konvin3190 (h1 , x(:,i), 0);
y2 = konvin3190 (h2 , x(:,i), 0);

y11_all(:,i) = y1; 
y22_all(:,i) = y2; 

end


x_offset_1 = y11_all(1001:1126,791);
x_offset_2 = y11_all(1001:1126,801);
tid = t(1001:1126);

figure;
hold on;
plot(tid,(x_offset_1));
plot(tid,(x_offset_2));
xlabel('tid[s]');
ylabel('Magnitude');
hold off;
%Her saa ser vi at reflaksjonen forsette ikke har delt seg ut fra
%refleksjonen til 2. sedimentaerlaget. Vi bruker samme maate aa estamilere 
%hastigheten som vi gjorde i oppgave7b. Henter ut offset i 791 og 801.
%Vi set at avstanden mellom er 100m, og tidsforskjellen er 0.032s.
%Derfor gir 2. sedimentaerlaget sin reflaksjon har ca. 3125m/s. 
%Dette er lavere enn 4000m/s og 3570m/s som vi har funnet i oppgave7b.
%Siden reflaksjonen vil foelge refleksjonen og deretter splitte ut
%refleksjonen. Dermed jo nearmere vi er til det splitt punktet, jo
%noeyaktigere vaare estamilingen er. Dermed er 3125m/s en mer noeyaktigere
%estamilering til reflaksjonshastighet til 2.sedimentaerlaget. 

%% Oppgave7d
clear;
load bihuic.mat;
load data.mat;
x = seismogram2;
y11_all = zeros(1501,801);
y22_all = zeros(1501,801);

%beregne y1 og y2 for alle signal i x
for i = 1:801
y1 = konvin3190 (h1 , x(:,i), 0);
y2 = konvin3190 (h2 , x(:,i), 0);

y11_all(:,i) = y1; 
y22_all(:,i) = y2; 
end

figure;
imagesc(offset2,t,y11_all,[caxis]);
colormap gray;
cc = caxis();
caxis([-0.001 0.001]);
xlabel('Offset[m]');
ylabel('Tid[s]');
