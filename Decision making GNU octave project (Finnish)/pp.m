%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FILE: pp.m
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paatosmatriisi (Kansalaisvapaudet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = [
 7  5  4  3 ; %% matkustusrajoituksia Jokomaahan
 8  5  6  3 ; %% karanteeneja Jokomaahan matkustaneille
 7  5  5  1 ; %% rajoja kiinni kaikkialle
 6  4  5  1 ; %% koko Suomen sulkeminen
 6  5  7  4 ; %% rokotteen odottaminen ja kaikkien pakkorokottaminen.
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Paatossaanto  V(p0,w) = 0.5*V_oa(p0) + 0.5*V_Hur(w)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paatosongelmien vakiokentat.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

po_Hur.pmat = R;
po_Hur.psaanto = "Hur";

po_oa.pmat = R;
po_oa.psaanto = "oa";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pienehkot taulukot erikseen p0 & w herkkyyksille.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 5;
koronatnt = linspace(0,1,n);
optasteet = linspace(0,1,n);

%% Pieni taulukko eri optimismin asteilla.
for i = 1:length(optasteet)
    w = optasteet(i);
    po_Hur.optaste = w;
    pr_Hur = pmatriisi(po_Hur);
    V_Hur(:,i) = pr_Hur.parvot;
end

%% Pieni taulukko eri Oliopoliotodennakoisyyksilla.
for i = 1:length(koronatnt)
    p0 = koronatnt(i);
    q0 = 1-p0;
    po_oa.tn = [p0/2  p0/2  q0/2  q0/2]';
    pr_oa = pmatriisi(po_oa);
    V_oa(:,i) = pr_oa.parvot;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Herkkyyskuva, kun p0 ja w vaihtelee.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Otteistustaajuus.  Kun N=500 laskeminen kestaa noin 20 sekuntia.
N = 500;

p0arvot = linspace(0,1,N);
warvot = linspace(0,1,N);
z = zeros(N);

for i=1:length(p0arvot)
    p0 = p0arvot(i);
    q0 = 1-p0;
    po_oa.tn = [p0/2  p0/2  q0/2  q0/2]';
    pr_oa = pmatriisi(po_oa);
    v_oa = pr_oa.parvot;
    v_oa = ( v_oa - min(v_oa) )/( max(v_oa) - min(v_oa) );
    for j=1:length(warvot)
        w = warvot(j);
        po_Hur.optaste = w;
        pr_Hur = pmatriisi(po_Hur);
        v_Hur = pr_Hur.parvot;
        v_Hur = ( v_Hur - min(v_Hur) )/( max(v_Hur) - min(v_Hur) );
        v = 0.5*( v_oa + v_Hur);
        [roskaa, z(j,i)] = max(v);
    end
end

contourf(p0arvot, warvot, z, [1 2 3 5])
set(gca, "fontsize", 24);
xlabel("p_0")
ylabel("w")
puna  = [1 0 0];
viher = [0 1 0];
kelta = [1 1 0];
colormap([0.6*viher; viher; kelta; puna])
%text(0.70,0.70,"a_1", "fontsize",20)
text(0.75,0.75,"a_2", "fontsize",20)
%text(0.10,0.10,"a_3", "fontsize",20)
text(0.25,0.25,"a_5", "fontsize",20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Herkkyyskuvan piirto PDF-tiedostoon.  Poista kommentit, jos haluat PDF:n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%orient("landscape");
%print("ee_herkkyyskuva.pdf");
