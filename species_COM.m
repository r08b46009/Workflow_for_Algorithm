pdb = pdbread('7l20-pdb-bundle/7l20-pdb-bundle2.pdb')
%pdb = getpdb('7L20');


X = [pdb.Model.Atom.X];
Y = [pdb.Model.Atom.Y];
Z = [pdb.Model.Atom.Z];
element = [pdb.Model.Atom.element];
chainID = [pdb.Model.Atom.chainID];

chain_ID = 'A';

X = X(chainID == chain_ID);
Y = Y(chainID == chain_ID);
Z = Z(chainID == chain_ID);

num_of_atom = numel(X);
coordinate = [X;Y;Z];
C = 12.0107;
N = 14.0067;
O = 15.999;
P = 30.973762;
S = 32.065;
currentX = 0;
currentY = 0;
currentZ = 0;
norm = 0;
normalizer = 0;
distanceX = 0;
distanceY = 0;
distanceZ = 0;
distance3D = 0;
num_of_histogram = 10;
mm = 0;
distance3D_normalized = 0;
e=0;
homo_sapiens=0;


for i = 1 : num_of_atom
   
    if element(1,i) == 'C'
        factor = C;
    elseif element(1,i) == 'N'
        factor = N;
    elseif element(1,i) == 'O'
        factor = O;
    elseif element(1,i) == 'P'
        factor = P;
    elseif element(1,i) == 'S'
        factor = S;
    end
norm = factor;
normalizer = normalizer+norm;
currentX = currentX+(X(1,i)* factor); 
currentY = currentY+(Y(1,i)* factor);
currentZ = currentZ+(Z(1,i)* factor);
% distanceX(1,i) = X(1,i);
% distanceY(1,i) = Y(1,i);
% distanceZ(1,i) = Z(1,i);

end
currentX = currentX/normalizer;
currentY = currentY/normalizer;
currentZ = currentZ/normalizer;
%for i = 1 : num_of_atom

%distanceX(1,i) = X(1,i)-currentX;
%distanceY(1,i) = Y(1,i)-currentY;
%distanceZ(1,i) = Z(1,i)-currentZ;
%distance3D(1,i) = ((X(1,i)-currentX)^2+(Y(1,i)-currentY)^2+(Z(1,i)-currentZ)^2)^(0.5);
%end