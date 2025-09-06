%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FILE: mip.m
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paatosmatriisi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%hauskuuden maaritys

R = [
2.5   3   4  4.5; %% Opintoja
 1    2   2   3;  %% opintoja ja baarimikkoilua
 1    3   2   4;  %% vähän opintoja ja paljon data-analysointia
 3   3.5  4   5;  %% vaihtoon Ruotsiin
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pienehko taulukko p0 herkkyyksille.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% p0 ja w otteistukset
p0arvot = 0:0.25:1;
warvot = 0:0.25:1;
arvot = 1:1:4;

%% Paatosongelmien vakiokentat
po1.pmat = R;
po1.psaanto = "oa";
po2.pmat = R;
po2.psaanto = "Lap";

%% Skaalattu paatossaanto V2
pr2 = pmatriisi(po2);
V2 = pr2.parvot;

%% Skaalattu paatokset V1
for i = 1:length(p0arvot)
    p = [
         p0arvot(i)/2;
         p0arvot(i)/2;
         (1-p0arvot(i))/2;
         (1-p0arvot(i))/2
        ];
    po1.tn = p;
    pr1 = pmatriisi(po1);
    V1(:,i) = pr1.parvot;
    V1(:,i) = (V1(:,i) - min(V1(:,i)))/(max(V1(:,i))-min(V1(:,i)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualisointi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Otteistustaajuus.  Mita isompi sen parempi, mutta laskeminen kestaa.
%% Jos N=500 laskeminen kestaa noin 20 sekuntia.
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
        po1.tn = [p0/2 p0/2 q0/2 q0/2]';
        pr1 = pmatriisi(po1);
        v1 = pr1.parvot;
        v1 = (v1-min(v1))/(max(v1)-min(v1));
        v = w*v1 + (1-w)*V2;
        [roskaa, z(j,i)] = max(v);
    end
end

%% Itse kuva
contourf(p0arvot, warvot, z, 1:4)
set(gca, "fontsize", 24);
xlabel("p_0")
ylabel("w")
puna  = [1 0 0];
viher = [0 1 0];
colormap([puna; 0.6*puna; viher; 0.6*puna])  %% Likainen jippo!!!!
%% a1 = puna
%% a2 = tumma puna
%% a3 = viher
%% a4 = tumma viher
%text(0.80,0.20,"a_1", "fontsize",24)
%text(0.20,0.10,"a_2", "fontsize",24)
%text(0.85,0.60,"a_3", "fontsize",24)
%text(0.20,0.60,"a_4", "fontsize",24)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Herkkyyskuvan piirto PDF-tiedostoon.  Poista kommentit, jos haluat PDF:n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%orient("landscape");
%print("uu_herkkyyskuva.pdf");
