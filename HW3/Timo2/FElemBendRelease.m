function elem = FElemBendRelease(nn,np)

elem.num_node = nn;
elem.num_intpoint = np;
switch(np)
    case 1
        elem.coord_intpoint = [0];
        elem.coord_intweight = [2];
    case 2
        elem.coord_intpoint = [-1/sqrt(3),1/sqrt(3)];
        elem.coord_intweight = [1,1];
    case 3
        elem.coord_intpoint = [-0.774596669241483,0,0.774596669241483];
        elem.coord_intweight = [5,8,5]/9;
    otherwise
        error('FBendRelease::Bad num_intpoint');
end

switch(nn)
    case 2
        elem.coord_node = [-1,1];
        fN = @(eta) [(1-eta)/2; (1+eta)/2];
        dfN = @(eta) [-1/2*eta.^0;1/2*eta.^0];
    case 3
        elem.coord_node = [-1,0,1];
        fN = @(eta) [eta.*(eta-1)/2;1-eta.^2 ;eta.*(eta+1)/2];
        dfN = @(eta) [(2*eta-1)/2;-2*eta ;(2*eta+1)/2];        
    otherwise
        error('FBendRelease::Bad num_node'); 
end

elem.NImr = fN(elem.coord_intpoint);
elem.dNIdLimr = dfN(elem.coord_intpoint);

% fN([-1,0,1])
% dfN([-1,0,1])








