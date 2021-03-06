function elem = FElemTimoBend(elem)
% ae=[w t w t...]

elem.Nw = zeros(elem.num_node*2,elem.num_intpoint);
elem.Nt = elem.Nw;
elem.dNw = elem.Nw;
elem.dNt = elem.Nw;
elem.Nw(1:2:end) = elem.NImr;
elem.Nt(2:2:end) = elem.NImr;
elem.dNw(1:2:end) = elem.dNIdLimr;
elem.dNt(2:2:end) = elem.dNIdLimr;
elem.fNw = @(eta) reshape([elem.fN(eta)';zeros(1,elem.num_node)],[],1);
elem.fNt = @(eta) reshape([zeros(1,elem.num_node);elem.fN(eta)'],[],1);


