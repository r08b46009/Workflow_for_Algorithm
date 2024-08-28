
bin = [];

spe = 7;
 species = ["new_Drosophila correct.xlsx";
   "new_ecoli.xlsx";
   "new_haloa.xlsx";
   "new_human.xlsx";
   "new_yeast.xlsx";
   "new_mito.xlsx";
   "new_thermo.xlsx";]


partition_file = ["partition_of_COM_of_Drosophila correct.xlsx";
 "partition_of_COM_of_ecoli.xlsx";
 "partition_of_COM_of_haloa.xlsx";
 "partition_of_COM_of_human.xlsx";
 "partition_of_COM_of_yeast.xlsx";
 "partition_of_COM_of_mito.xlsx";
 "partition_of_4v51_thermo.xlsx";
 
]

name3 = ["fly_partition_coordinate1.xlsx";
    "ecoli_partition_coordinate1.xlsx";
    "haloa_partition_coordinate1.xlsx";
    "human_partition_coordinate1.xlsx";
    "yeast_partition_coordinate1.xlsx";
    "mito_partition_coordinate1.xlsx";
    "thermo_partition_coordinate1.xlsx";
    ]

[data, name, sum] = xlsread(species(spe));

Sum = cell2table(sum);



residue = string(Sum(:,1).sum1);
X = string(Sum(:,2).sum2);
Y = string(Sum(:,3).sum3);
Z = string(Sum(:,4).sum4);
weight = string(Sum(:,5).sum5);

accu_x = zeros(numel(X),1);
accu_y = zeros(numel(X),1);
accu_z = zeros(numel(X),1);
accu_weight = zeros(numel(X),1);
X = str2double(X);

Y = str2double(Y);

Z = str2double(Z);

weight = str2double(weight);

[data, name, sum] = xlsread(partition_file(spe));

Sum = cell2table(sum);
bin = string(Sum(:,2).sum2);

bin = str2double(bin);

n = [106];
for i = 1 : numel(n)
    bin(n(i),1) = 19;
    X(n(i),1) = 0;
    Y(n(i),1) = 0;
    Z(n(i),1) = 0;
    weight(n(i),1) = 0;
end
x = 0;
y = 0;
z = 0;
% 
% Residue(23,2) = "23";
% Residue(43,2) = "23";
% Residue(44,2) = "23";
% Residue(85,2) = "23";
% Residue(38,2) = "23";

for i = 1 : numel(bin)
    if(ismissing(bin(i)))
        continue;
    end
% % 
%      if i >115
%          break;
%      end
    accu_x(bin(i)) = accu_x(bin(i)) + weight(i)*X(i);
    accu_y(bin(i)) = accu_y(bin(i)) + weight(i)*Y(i);
    accu_z(bin(i)) = accu_z(bin(i)) + weight(i)*Z(i);
    accu_weight(bin(i)) = accu_weight(bin(i)) + weight(i);

end

for i = 1 : numel(accu_weight)
    accu_x(i) = accu_x(i) / accu_weight(i);
    accu_y(i) = accu_y(i) / accu_weight(i);
    accu_z(i) = accu_z(i) / accu_weight(i);
end
distance3D = [accu_x, accu_y, accu_z, accu_weight]
writematrix(distance3D,name3(spe));
% writematrix([accu_x, accu_y, accu_z, accu_weight],[name(1)]);