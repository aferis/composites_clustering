[X,~,Xraw]=xlsread('Materialbank.xlsx'); 

% % Eingaben:
% m: Welche Merkmalen werden benutzt? (z.B. Merkmalen 1, 2 => m=[1 2])
% metrik: Distanzmetrik für kmeans (z.B. metrik='sqeuclidean')
% a: minimaler k-Wert für die Evaluierung der Cluster (z.B. a=2)
% b: maximaler k-Wert für die Evaluierung der Cluster (z.B. b=10)
% n: Wievielmal soll die GMM-Analyse wiederholt werden? (z.B. n=5)

%%Boolesche Operatoren
%b1: Definieren Sie b1=1 für Streudiagramm, sonst b1=0
%b2: Definieren Sie b2=1 für Silhouettendiagramm, sonst b2=0
%b3: Definieren Sie b3=1 für Gaußsche Mischverteilung, sonst b3=0
%b4: Definieren Sie b4=1 für %Parallele Koordinaten, sonst b4=0
%b5: Definieren Sie b5=1 für %Paretodiagramm, sonst b5=0

A=X(:,m);%neu definierte Matrix mit der Eingabe m
N=normalize(A,'range'); %Normalisierung im Bereich von 0 bis 1
eva=evalclusters(A,'kmeans','silhouette','KList',a:b); %Bewertung des k-Means-Clusterverfahrens
evaN=evalclusters(N,'kmeans','silhouette','KList',a:b); %Bewertung des k-Means-Clusterverfahrens mit Normalisierung
k=eva.OptimalK; %Optimale Clusteranzahl
kN=evaN.OptimalK; %Optimale Clusteranzahl mit Normalisierung
obs=eva.NumObservations; %Definieren der Anzahl der Objekte
[i,C]=kmeans(A,k,'Distance',metrik); %K-means-Clustering 
[iN,CN]=kmeans(N,kN,'Distance',metrik); %normalisierte k-Means-Clustering 
merkmal=Xraw(1,2:end); %Definieren der Merkmalnamen
if k==2
        colors='br';
        markers='+*';
elseif k==3
        colors='brg';
        markers='+*x';
elseif k==4
        colors='brgm';
        markers='+*xo';
elseif k==5
        colors='brgmc';
        markers='+*xod';
end
clust={'Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5'};

%%Plot 
if b1==1
    if length(m)==2 %Plot 2D
        figure('Name','2D Clustering')
        gscatter(A(:,1),A(:,2),i,colors,markers)
        title('K-Means-Verfahren')
        xlabel(merkmal{m(1)})
        ylabel(merkmal{m(2)})
        grid on; zoom on; hold on;
        plot(C(:,1),C(:,2),'kx','MarkerSize',10,'LineWidth',2)
        legend(clust{1,1:k}, 'Clusterzentren','Location','SE')
    elseif length(m)==3 %Plot 3D
        figure('Name','3D Clustering')
        [~,~,id] = unique(i);
        for idx=1:k
            data = A(id == idx,:);
            plot3(data(:,1),data(:,2),data(:,3),[colors(idx) markers(idx)]);
            hold on;
        end
        title('K-Means-Verfahren')
        xlabel(merkmal{m(1)})
        ylabel(merkmal{m(2)})
        zlabel(merkmal{m(3)})
        grid on; zoom on; hold on;
        plot3(C(:,1),C(:,2),C(:,3),'kx','MarkerSize',10,'LineWidth',2)
        legend(clust{1,1:k},'Clusterzentren','Location','SE')
    end
end
if b2==1
    %Evaluierung mit Silhouettendiagramm
    figure('Name','Silhouetten')
    silhouette(A,i)
    title('Silhouettendiagramm')
end
if length(m)==2 && b3==1
    %Gaußsche Mischverteilung mit der Eingabe n 
    figure('Name','GMM') 
    gmm=fitgmdist(A,k,'Replicates',n);
    g=cluster(gmm,A);
    gscatter(A(:,1),A(:,2),g)
    xlabel(merkmal{m(1)})
    ylabel(merkmal{m(2)})
    title('GMM')
end
d=pdist(A); %paarweise Abstände zwischen Objekten
d(isnan(d))=[]; %Löschen der NaN-Werte
[Y,e]=cmdscale(d); 
N=normalize(A,'range'); %Normalisierung im Bereich von 0 bis 1
if b4==1
    figure('Name','Parallel') %normalisierte Evaluierung mit parallelen Koordinaten
    parallelcoords(N,'Group',i)
    title('Parallele Koordinaten')
end
[pcs,scrs,~,~,pexp]=pca(N,'Algorithm','als'); %PCA
if b5==1
    figure('Name','Pareto')
    pareto(pexp) % Prozent der Varianz
    title('Varianz')
end