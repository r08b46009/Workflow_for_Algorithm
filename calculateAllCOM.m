function [CenterOfMass, A] = calculateAllCOM(fileName, chain_ID) %算NUCLEOTIDE &SAVE TO EXCEL
fileName = convertStringsToChars(fileName);
pdb = pdbread(fileName);
disp(['reading ' fileName]);
[filePath, name, ext] = fileparts(fileName);
if ~exist(name, 'dir')  %%exist 是內建的, 用來判斷一個檔案是否存在 第一個參數是名稱, 第二個參數是類型 
   mkdir(name)
end
X = [pdb.Model.Atom.X];  %%取pdb所有原子的x座標
Y = [pdb.Model.Atom.Y];
Z = [pdb.Model.Atom.Z];

element = [pdb.Model.Atom.element];
chainID = [pdb.Model.Atom.chainID];

X = X(chainID == chain_ID);
Y = Y(chainID == chain_ID);
Z = Z(chainID == chain_ID);

resSeq = [pdb.Model.Atom.resSeq]; %%residue的number
resName = [pdb.Model.Atom.resName]; %%residue的種類

element = element(chainID == chain_ID);
chainID = chainID(chainID == chain_ID);

num_of_atom = numel(X); 

C = 12.0107;
N = 14.0067;
O = 15.999;
P = 30.973762;
S = 32.065;
COT(1).resName = 'G';
COT(1).resIdx = 0;
COT(1).weightX = 0;
COT(1).weightY = 0;
COT(1).weightZ = 0;

resIdx = resSeq(1, 1);  %resSeq(1, 1) == 1

offset = resIdx - 1;
i = 1;
j = i;
fileIdx = 1;

i = 1;
while(i < num_of_atom)
    j = i;
    totalWeight = 0;
    atomWeight = 0;
    count = 0;
    weightX = 0;
    weightY = 0;
    weightZ = 0;
    while(j < num_of_atom && resIdx == resSeq(1, j))
        if element(1, j) == 'C'
            atomWeight = C;
        elseif element(1, j) == 'N'
            atomWeight = N;
        elseif element(1, j) == 'O'
            atomWeight = O;
        elseif element(1, j) == 'P'
            atomWeight = P;
        elseif element(1, j) == 'S'
            atomWeight = S;
        end

        weightX = weightX + X(1, j) * atomWeight;
        weightY = weightY + Y(1, j) * atomWeight;
        weightZ = weightZ + Z(1, j) * atomWeight;
        totalWeight = totalWeight + atomWeight;
        count = count + 1;
        j = j + 1;

    end

    if(resIdx < numel(COT) && resIdx == 1)
        saveCOMtoXLSX(COT,fileIdx,name);
        fileIdx = fileIdx + 1;
        COT = [];
    end
    COT(resIdx - offset).resName = resName(1, j - 1);
    COT(resIdx - offset).resIdx = resIdx;
    COT(resIdx - offset).weightX = weightX;
    COT(resIdx - offset).weightY = weightY;
    COT(resIdx - offset).weightZ = weightZ;
    COT(resIdx - offset).totalWeight = totalWeight;
    COT(resIdx - offset).COMX = weightX / totalWeight;
    COT(resIdx - offset).COMY  = weightY / totalWeight;
    COT(resIdx - offset).COMZ  = weightZ / totalWeight;
    COT(resIdx - offset).count = count;

    resIdx = resSeq(1, j);  %resSeq(1, j)可indicate residue的index(編號)

    i = j;

end
saveCOMtoXLSX(COT,fileIdx,name);
CenterOfMass = COT;
A = pdb.Model.Atom;

end


function [] = saveCOMtoXLSX(COMdata, fileIdx, fileName)
fileName = strcat(fileName, "/");
folder = convertStringsToChars(fileName);
prefix = 'CenterOfMass-';
ext = '.xlsx';
filenum = num2str(fileIdx);
cotfile = [folder prefix filenum ext];
writetable(struct2table(COMdata), cotfile);
end




