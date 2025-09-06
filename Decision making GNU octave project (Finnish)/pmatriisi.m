function ptulos = pmatriisi(pongelma)  
%% Funktio ptulos = pmatriisi(pongelma) palauttaa rakennemuuttujan ptulos, jonka
%% kentta  parvot  kertoo eri valintojen arvot ja kentta  poptimi  kertoo 
%% optimaalisen paatoksen indeksin.  Mikali paatossaanto on "kk", palauttaa 
%% kentta  kmat  katumusmatriisin, ja mikali paatossaanto on "vara", palauttaa
%% kentta  hmat  hyotymatriisin.
%%
%% Argumentti pongelma on rakennemuuttuja, joka kuvaa paatosongelman. Sen kentat
%% ovat
%%
%% pmat on palkkiomatriisi.
%% psaanto on merkkijono, joka kertoo paatossaannon.  
%%     Tuettuja saantoja ovat "opt", "pess", "Hur", "kk", "Lap", "oa", "vara".
%% optaste on optimismin aste Hurwiczin saannossa.
%% tn on pystyvektori skenaarioiden todennakoisyyksille.
%% rtol on "vara"-saantoon liittyva riskitoleranssi.

    %% Lyhennysmerkintoja
    R = pongelma.pmat;
    s = pongelma.psaanto;
    I = 1:rows(R);         %% Matlabissa I = 1:size(R)(1);
    J = 1:columns(R);      %% Matlabissa J = 1:size(R)(2);
    
    if strcmp(s,"opt") 
        ptulos.parvot = max(R')';
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);
    elseif strcmp(s,"pess")
        ptulos.parvot = min(R')';
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);    
    elseif strcmp(s,"Hur") 
        w = pongelma.optaste;
        ptulos.parvot = w*max(R')' + (1-w)*min(R')';
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);
    elseif strcmp(s,"kk")
        %% Rakennetaan katumusmatriisi
        for i=I
            for j=J
                K(i,j) = max(R(:,j)) - R(i,j);
            end
        end
    ptulos.parvot = max(K')';
    [roskaa, ptulos.poptimi] = min(ptulos.parvot);
    ptulos.kmat = K; 
    elseif strcmp(s,"Lap")
        ptulos.parvot = (1/columns(R))*sum(R')';
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);
    elseif strcmp(s,"oa")
        p = pongelma.tn;
        ptulos.parvot = R*p;        %%  p:n on oltava pystyvektori!
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);
    elseif strcmp(s,"vara")
        p = pongelma.tn;
        r0 = pongelma.rtol;
        %% Rakennetaan hyotymatriisi.
        for i=I
            for j=J
               U(i,j) = 1 - exp(-R(i,j)/r0);
            end
        end
        ptulos.parvot = U*p;
        [roskaa, ptulos.poptimi] = max(ptulos.parvot);
        ptulos.hmat = U;
    end
end