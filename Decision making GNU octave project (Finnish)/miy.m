%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FILE: miy.m
% Merkkaan tiedostossa itseani lyhenteella tai kirjaimella M ja Peppiinaa kirjaimella P
%
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

RM1 = [
ts-0.6*ms     ts-0.8*ms       ts-0.8*ms      ts-ms;
ts+0.5*bm-ms ts+0.7*bm-1.1*ms ts+0.8*bm-1.1*ms  ts+bm-1.25*ms;
ts+da*0.2-ms 0.5*t+ol+da*0.75-1.25*ms ts+da*0.4-ms ol+da-1.5*ms;
tr-0.6*mr-rm  tr-0.8*mr-rm  tr-0.8*mr-rm  tr-mr-rm;
];
%
%% Jaljella oleva valmistumisaika syksylla 2022 (tavoiteaika on yksi vuosi!!!)

RM2 = [
1 1 1 1;
1.5 1.5 2 2;
2 3 2.5 3.5;
1.5 1.5 1.5 1.5;
];

RM2 = -RM2;        %% Maksimointimuoto!

%% Hauskuus

RP = [
2.5   3   4  4.5; %% Opintoja
 1    2   2   3;  %% opintoja ja baarimikkoilua
 1    3   2   4;  %% vähän opintoja ja paljon data-analysointia
 3   3.5  4   5;  %% vaihtoon Ruotsiin
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualisointi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Paatosongelmien vakiokentat
poM1.pmat = RM1;
poM1.psaanto = "oa";
poM2.pmat = RM2;
poM2.psaanto = "oa";

poP1.pmat = RP;
poP1.psaanto = "oa";
poP2.pmat = RP;
poP2.psaanto = "Lap";

%% Peppiinan taulukko voidaan laskea valmiiksi, sillä se ei vaadi oliopoliotodennakoisyyksia
prP2 = pmatriisi(poP2);
VP2 = prP2.parvot;

%% Otteistustaajuus.  Mita isompi sen parempi, mutta laskeminen kestaa.
%% Jos N=500 laskeminen kestaa noin minuutin.
N=50;

%% Laskut
p0arvot = linspace(0,1,N);
warvot = linspace(0,1,N);
z = zeros(N);

for i=1:length(p0arvot)
    for j=1:length(warvot)
        p0 = p0arvot(i);
        w = warvot(j);
        q0 = 1-p0;
        poM1.tn = [p0/2 p0/2 q0/2 q0/2]';
        poM2.tn = [p0/2 p0/2 q0/2 q0/2]';
        poP1.tn = [p0/2 p0/2 q0/2 q0/2]';
        prM1 = pmatriisi(poM1);
        prM2 = pmatriisi(poM2);
        prP1 = pmatriisi(poP1);
        VM = 0.5*prM1.parvot + 0.5*prM2.parvot;
        VM = (VM-min(VM))/(max(VM)-min(VM));
        VP = 0.5*prP1.parvot + 0.5*VP2;
        VP = (VP-min(VP))/(max(VP)-min(VP));
        V = w*VM + (1-w)*VP;
       [roskaa, z(j,i)] = max(V);
    end
end

%% Itse kuva
contourf(p0arvot, warvot, z, 1:4)
set(gca, "fontsize", 24);
xlabel("p_0")
ylabel("w")
puna  = [1 0 0];
viher = [0 1 0];
colormap([puna; 0.5*puna; viher; 0.6*viher])
%% a1 = puna
%% a2 = tumma puna
%% a3 = viher
%% a4 = tumma viher
%text(0.70,0.50,"a_1", "fontsize",24)
%text(0.20,0.10,"a_2", "fontsize",24)
text(0.50,0.70,"a_3", "fontsize",24)
text(0.50,0.255,"a_4", "fontsize",24)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Herkkyyskuvan piirto PDF-tiedostoon.  Poista kommentit, jos haluat PDF:n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%orient("landscape");
%print("ssuu_herkkyyskuva.pdf");
