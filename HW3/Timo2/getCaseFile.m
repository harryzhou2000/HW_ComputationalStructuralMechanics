function casefilename = getCaseFile(name)

casefilename = ['CASEtimo_',name];
casefilename = replace(casefilename,{'.','-'},{'d','m'});
casefilenameF = [casefilename,'.m'];
pdouble = '[+-]?\d*\.?\d+[eE]?[+-]?\d*';
params = regexp(name,['([23])([pr])(\d+)_h(',pdouble,')_L([12])'],'tokens');
if(numel(params) ~=1)
    error('bad case name');
end
fout = fopen(casefilenameF,'w');

nn = str2double(params{1}{1});
if(params{1}{2} == 'p')
    if(nn == 3)
        np = 3;
    elseif(nn ==2)
        np = 2;
    end
elseif(params{1}{2} == 'r')
    if(nn == 3)
        np = 2;
    elseif(nn ==2)
        np = 1;
    end
end




fprintf(fout,'nn=%d;np=%d; %%numnode and num intpoint \n',nn,np);
fprintf(fout,'Ne = %s; %%num elem \n',params{1}{3});
fprintf(fout,'h = %s; %%height of beam\n',params{1}{4});
fprintf(fout,'loadform = %s; %distributed load\n',params{1}{5});
fprintf(fout,'L = 1;rho = 1e3*1;E = 1e9;nu = 0;G = E/(2*(nu+1));b = 0.1;nmode = 5;');


fclose(fout);