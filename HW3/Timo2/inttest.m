ec = FElemBendRelease(3,3);
f = @(x) (x+0.5).^5;
fs = f(ec.coord_intpoint);
integral(f,-1,1)-fs*ec.coord_intweight'

ec = FElemBendRelease(3,2);
f = @(x) (x+0.8).^3;
fs = f(ec.coord_intpoint);
integral(f,-1,1)-fs*ec.coord_intweight'