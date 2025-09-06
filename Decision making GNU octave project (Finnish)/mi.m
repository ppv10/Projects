%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FILE: mi.m

t = 5*600;          %% Tuet yhteensä
ol = 3250;          %% Opintolaina
kol = 3800;         %% Korotettu opintolaina Ruotsiin
s = 1500;           %% Opiskelijavaihtostipendi Ruotsiin
rm = 500;           %% Ruotsin muuttokustannukset
ms = 5*400;         %% Elamisen kulut Suomessa
mr = 5*400;         %% Elamisen kulut Ruotsissa

tr = kol+t+s-mr;     %% Opiskelijan tulot Ruotsissa
ts = t+ol;           %% Opiskelijan tulot Suomessa

bm = 5*1000*0.95;     %% Baarimikon "nettoperuspalkka"
da = 5*2500*0.8;      %% Data-analysoijan "nettoperuspalkka"

R1 = [
ts-0.6*ms     ts-0.8*ms       ts-0.8*ms      ts-ms;
ts+0.5*bm-ms ts+0.7*bm-1.1*ms ts+0.8*bm-1.1*ms  ts+bm-1.25*ms;
ts+da*0.2-ms 0.5*t+ol+da*0.75-1.25*ms ts+da*0.4-ms ol+da-1.5*ms;
tr-0.6*mr-rm  tr-0.8*mr-rm  tr-0.8*mr-rm  tr-mr-rm;
];

%% Jaljella oleva valmistumisaika syksylla 2024 (tavoiteaika on yksi vuosi!!!)

R2 = [
1 1 1 1;
1.5 1.5 2 2;
2 3 2.5 3.5;
1.5 1.5 1.5 1.5;
];

R2 = -R2;        %% Maksimointimuoto!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pienehkot taulukot p0 ja w herkkyyksille.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% p0 ja w otteistukset
p0arvot=0:0.25:1;
warvot=0:0.25:1;

%% Paatosongelmien vakiokentat
po1.pmat = R1;
po1.psaanto = "oa";
po2.pmat = R2;
po2.psaanto = "oa";

%% Skaalattu paatokset V1 ja V2
for i = 1:length(p0arvot)
    p = [
         p0arvot(i)/2;
         p0arvot(i)/2;
         (1-p0arvot(i))/2;
         (1-p0arvot(i))/2
         ];
    po1.tn = p;
    po2.tn = p;
    pr1 = pmatriisi(po1);
    pr2 = pmatriisi(po2);
    V1(:,i) = pr1.parvot;
    V1(:,i) = (V1(:,i) - min(V1(:,i)))/(max(V1(:,i))-min(V1(:,i)));
    V2(:,i) = pr2.parvot;
    V2(:,i) = (V2(:,i) - min(V2(:,i)))/(max(V2(:,i))-min(V2(:,i)));
end

%% Arvojen tasapainoinen (w=0.5) yhdistaminen, kun p0=0:0.25:1
V = 0.5*V1 + 0.5*V2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualisointi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Otteistustaajuus.  Mita isompi sen parempi, mutta laskeminen kestaa.
%% Jos N=500 laskeminen kestaa vajaan minuutin.
N=50;

%% Laskut
p0arvot = linspace(0,1,N);
warvot = linspace(0,1,N);
z = zeros(N);

for i=1:length(p0arvot)
    for j=1:length(warvot)
         p0 = p0arvot(i);
         w = warvot(j);
         q0 = 1-p0
         po1.tn = [p0/2 p0/2 q0/2 q0/2]';
         po2.tn = [p0/2 p0/2 q0/2 q0/2]';
         pr1 = pmatriisi(po1);
         pr2 = pmatriisi(po2);
         v1 = pr1.parvot;
         v1 = (v1-min(v1))/(max(v1)-min(v1));
         v2 = pr2.parvot;
         v2 = (v2-min(v2))/(max(v2)-min(v2));
         v = w*v1 + (1-w)*v2;
         [roskaa, z(j,i)] = max(v)
   end
end

%% Itse kuva
contourf(p0arvot, warvot, z,1:4)
set(gca, "fontsize", 24);
xlabel("p_0")
ylabel("w")
puna  = [1 0 0];
viher = [0 1 0];
colormap([puna; 0.6*puna; viher; 0.6*viher])
% a1 = puna
% a2 = tumma puna
% a3 = viher
% a4 = tumma viher
text(0.50,0.20,"a_1", "fontsize",24)
text(0.50,0.58,"a_2", "fontsize",24)
text(0.50,0.85,"a_3", "fontsize",24)
%text(0.10,0.85,"a_4", "fontsize",24)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Herkkyyskuvan piirto PDF-tiedostoon.  Poista kommentit, jos haluat PDF:n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%orient("landscape");
%print("mi_herkkyyskuva.pdf");
