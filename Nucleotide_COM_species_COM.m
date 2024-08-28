function [result,RESULT,T1] = Nucleotide_COM_species_COM(fileName, x, y, z)

intervalWidth = 7;
file = fileName;
disp(['reading ' file]);







[data, name, sum] = xlsread(file);

Sum = cell2table(sum);


residue = string(Sum(:,1).sum1);
X = string(Sum(:,2).sum2);
Y = string(Sum(:,3).sum3);
Z = string(Sum(:,4).sum4);
weight = string(Sum(:,5).sum5);


X = str2double(X);

Y = str2double(Y);

Z = str2double(Z);

weight = str2double(weight);

validIndices = (X ~= 0 & Y ~= 0 & Z ~= 0 & weight ~= 0);
residue = residue(validIndices);
X = X(validIndices);
Y = Y(validIndices);
Z = Z(validIndices);
weight = weight(validIndices);

%start calculating
num_of_residue = numel(X);

distance3D = zeros(numel(X),1);
distance3D_1 = zeros(numel(X),2);
Residue = strings(numel(X),1);


disp(['total residue: ' num2str(num_of_residue)]);
for i = 1 : num_of_residue
    distance3D(i,1) = ((X(i, 1)-x)^2+(Y(i, 1)-y)^2+(Z(i, 1)-z)^2)^(0.5);
    distance3D_1(i,1) = ((X(i, 1)-x)^2+(Y(i, 1)-y)^2+(Z(i, 1)-z)^2)^(0.5);
    distance3D_1(i,2) = weight(i, 1);
    Residue(i,1) = residue(i, 1);
end

numIntervals = (max(distance3D)-min(distance3D))/intervalWidth;
% fprintf(numIntervals);
%numIntervals = int16(numIntervals)+1;

% numIntervals = 15;

disp(['numIntervals: ' convertStringsToChars(num2str(numIntervals))]);

% intervalWidth = (max(distance3D) - min(distance3D))/numIntervals;

T1 = [distance3D, Residue];

%intervalWidth = 10; %跟上面的比,選一個

%x = 0:intervalWidth:175;
%x = 0:intervalWidth:175;



%ncount =  histcounts(distance3D,'BinWidth',intervalWidth);
%[N, edges] = histcounts(distance3D,numIntervals)
%fprintf('histcounts: ');
%for i = 1 : length(ncount)
%    fprintf('%d ', ncount(1, i));
%end
%fprintf('\n');
%result = ncount; 
%RESULT= numIntervals;

result = 0;
RESULT = 0;
%hist(distance3D, 10);
%hist(distanceY, 8000);
%saveas(gcf,'Y.png');
%hist(distanceZ, 8000);
%saveas(gcf,'Z.png');
end