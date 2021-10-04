clc;close all;
%% Inputs and Pres
nn=3;np=2;
% nn=2;np=1;
Ne = 1;
nmode = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Material & Geom  %%%%%%
% L = 3;
% rho = 2.5e3*1;
% E = 25.5e9;
% nu = 0.27;
% G = E/(2*(nu+1));
% h = 0.6;
% b = 0.3;
L = 1;
rho = 1e3*1;
E = 1e9;
nu = -0.5;
G = E/(2*(nu+1));
h = 100; 
b = 0.1;

Iy = h^3*b/12;
A = h*b;
k = 6/5;
mat.EIy = E*Iy;
mat.GAdk = G*A/k;
mat.rhoA = A * rho;
mat.rhoIy = Iy * rho;
%%%%%%  Material & Geom  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nnode = nn*Ne-(Ne-1);
xnode = linspace(0,L,Nnode);
ndof = Nnode * 2;

elem = FElemBendRelease(nn,np);
elem = FElemTimoBend(elem);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%    Load and BC    %%%%%%
Pdist = ones(1,Nnode)*0;
Mdist = ones(1,Nnode,1)*0;
PPdist = reshape([Pdist;Mdist],1,[]);

Pc = ones(1,Nnode)*0;
Mc = ones(1,Nnode,1)*0;
Mc(end) = 1;
PPc = reshape([Pc;Mc],1,[]);

Pfix = nan(1,Nnode);
Mfix = nan(1,Nnode);
Pfix(1) = 0;
Mfix(1) = 0; % Cantilever
% Pfix(end) = 0;
PPfix = reshape([Pfix;Mfix],1,[]);
%%%%%%    Load and BC    %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Calculation
%%%%----Assembly
% K = spalloc(ndof,ndof,ndof*5);
% M = K;
P = zeros(ndof,1);
Nmat = ndof*5;
Ki = nan(Nmat,1);Kj = Ki;Kv = Ki;
% Mi = nan(Nmat,1);Mj = Mi;
Mv = Ki;
nfill = 0;

for ie = 1:Ne
   localNodes=(nn-1)*(ie-1)+1:(nn-1)*ie+1;
   localDOFs = reshape([localNodes*2-1;localNodes*2],1,[]);
   
   [Ke,Pe,Me] = ...
       FLocalsTimoBend(xnode(localNodes),...
       PPdist(localDOFs),...
       elem.coord_node,...
       PPc(localDOFs),...
       PPfix(localDOFs),...
       elem,mat);
    js =  ones(numel(localDOFs),1)*localDOFs;
    is = js';
    is = is(:);
    js = js(:);
    
    nfillstart = nfill +1;
    nfill = nfill + numel(localDOFs)^2;

    P(localDOFs) = P(localDOFs) + Pe;
    Ki(nfillstart:nfill) = is;
    Kj(nfillstart:nfill) = js;
    Kv(nfillstart:nfill) = Ke(:);
    Mv(nfillstart:nfill) = Me(:);
%    M(localDOFs,localDOFs) = M(localDOFs,localDOFs) + Me;
%    K(localDOFs,localDOFs) = K(localDOFs,localDOFs) + Ke;
    if(mod(ie,10000)==0 || ie == Ne)
       fprintf('Assmbly %.2f%%\n',ie/Ne*100); 
    end
end

K = sparse(Ki(1:nfill),Kj(1:nfill),Kv(1:nfill));
M = sparse(Ki(1:nfill),Kj(1:nfill),Mv(1:nfill));
fprintf('Assembly Done\n');
%%%%----Assembly

%%%%----Solve
A = K\P;

Ar = reshape(A,2,[]);
figure(1);
plot(xnode,Ar(1,:));
%%%%----Solve

%%%%----solve eigs
[V,D] = eigs(K,M,nmode,'smallestabs');

figure(2);
clf;hold on;
for i = 1:min(nmode,3)
    Mr = reshape(V(:,i),2,[]);
    plot(xnode,Mr(1,:),'DisplayName',sprintf('f=%.6g',sqrt(D(i,i))));
end
legend

fprintf('\nFreqs:\n');
fprintf('mode %d: %.12g\n',[1:nmode;sqrt(diag(D))']);
%%%%----solve eigs






