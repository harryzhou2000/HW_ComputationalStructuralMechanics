clc; clear; close all;
%%
% form:  2p1 2p10 2p10000 2r1 2r2 2r10000 3p1  3p2 3p10000 3r1 3r2 3r10000
%        1   2    3       4   5   6       7    8   9       10  11  12
%h1
%h0.1
%h0.01

%% load 1 dist force load

nameA = {'2p1' '2p10' '2p10000' '2r1' '2r10' '2r10000' '3p1'  '3p2' '3p10000' '3r1' '3r10' '3r10000' };
nameB = {'h1','h0.1','h0.05','h0.01'};


name = '2p1_h0.01_L1';
fname = getCaseFile(name);

dispsL1 = nan(12,4);

for iA = 1:12
    for iB = 1:4
        name = [nameA{iA},'_',nameB{iB},'_L1'];
        fname = getCaseFile(name);
        eval(fname);
        TimoCalculate;
        dispsL1(iA,iB) = enddisp;
    end
end

%% load 2 bend load

nameA = {'2p1' '2p10' '2p10000' '2r1' '2r10' '2r10000' '3p1'  '3p10' '3p10000' '3r1' '3r10' '3r10000' };
nameB = {'h1','h0.1','h0.05','h0.01'};

dispsL2 = nan(12,4);

for iA = 1:12
    for iB = 1:4
        name = [nameA{iA},'_',nameB{iB},'_L2'];
        fname = getCaseFile(name);
        eval(fname);
        TimoCalculate;
        dispsL2(iA,iB) = enddisp;
    end
end
%%
linesL2 = cell(1,12);
linesL1 = cell(1,12);
for i = 1:12
   linesL2{i} = sprintf([repmat('&%.15E',1,4),'\\\\'],dispsL2(i,:));
   linesL1{i} = sprintf([repmat('&%.15E',1,4),'\\\\'],dispsL1(i,:));
end



