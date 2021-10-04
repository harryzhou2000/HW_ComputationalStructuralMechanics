function [K,P,M] = FLocalsTimoBend(coords,Pdist,etaPconc,Pconc,Pfix,elem,materialBeam)

K = zeros(elem.num_node*2);
P = zeros(elem.num_node*2,1);
if(nargout >2)
    M = K;
end

for ip = 1:elem.num_intpoint
    Jacobi = coords*elem.dNIdLimr(:,ip);
    iJacobi = inv(Jacobi);
    dNtdx = iJacobi * elem.dNt(:,ip)';
    dNwdx = iJacobi * elem.dNw(:,ip)';
    Bs = dNwdx + elem.Nt(:,ip)';
    Pwdist = Pdist * elem.Nw(:,ip);
    Ptdist = Pdist * elem.Nt(:,ip);
    K = K + ...
        (materialBeam.EIy * (dNtdx' * dNtdx) + ...
        materialBeam.GAdk * (Bs' * Bs)) ...
        * Jacobi * elem.coord_intweight(ip);
    
    P = P + ...
        (elem.Nw(:,ip)*Pwdist + elem.Nt(:,ip)*Ptdist)...
        * Jacobi * elem.coord_intweight(ip);
    if(nargout >2)
        M = M + ((elem.Nw(:,ip)*elem.Nw(:,ip)') * materialBeam.rhoA...
            +(elem.Nt(:,ip)*elem.Nt(:,ip)') * materialBeam.rhoIy)* ...
            Jacobi * elem.coord_intweight(ip);
    end
end

for iconc = 1:numel(etaPconc)
    P = P + elem.fNw(etaPconc(iconc)) * Pconc(iconc*2-1);
    P = P + elem.fNt(etaPconc(iconc)) * Pconc(iconc*2-0);
end

for idof = 1:elem.num_node*2
    if(~isnan(Pfix(idof)))
        K(idof,idof) = K(idof,idof)*1e5;
        P(idof) = K(idof,idof)*Pfix(idof);
    end
end







