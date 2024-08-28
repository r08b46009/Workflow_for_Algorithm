output = ["distance_of_Drosophila_correct.xlsx";
    "distance_of_ecoli.xlsx";
    "distance_of_haloa.xlsx";
    "distance_of_human.xlsx";
    "distance_of_yeast.xlsx";
    "distance_of_mito.xlsx";
    "distance_of_thermo.xlsx"];

partition_file = ["partition_of_COM_of_Drosophila_correct.xlsx";
    "partition_of_COM_of_ecoli.xlsx";
    "partition_of_COM_of_haloa.xlsx";
    "partition_of_COM_of_human.xlsx";
    "partition_of_COM_of_yeast.xlsx";
    "partition_of_COM_of_mito.xlsx";
    "partition_of_thermo.xlsx"];

numIntervals = 17; 
n = 1;
a = zeros(140);
lis = {};

input_dir = 'Distance'; % 输入文件所在的目录
output_dir = 'partition'; % 输出文件所在的目录

if ~exist(output_dir, 'dir')
    mkdir(output_dir); % 如果输出目录不存在，则创建
end

for i = 1: 7
    file = fullfile(input_dir, output(i));
    disp(['reading ' file]);

    weight = [];
    Distance3D = []; 

    [data, name, sum] = xlsread(file);
    Sum = cell2table(sum);

    Distance3D = str2double(string(Sum(:,1).sum1));
    weight = str2double(string(Sum(:,2).sum2));
%     residue = string(Sum(:,3).sum3);
    Residue = str2double(string(Sum(:,2).sum2));

    intervalWidth = 7;
    disp(intervalWidth);

    weight(isnan(weight)) = 0;

    for k = 1 : size(weight)
        mm = 0;
        fprintf("%d\n", k);
        for j = 1 : numIntervals + 7
            deposit_residue = strings(1, numIntervals + 7);
%             fprintf("numIntervals%d",numIntervals);

%             if(min(Distance3D) + (j-1)*intervalWidth < max(Distance3D)) 
            if min(Distance3D) + intervalWidth*(j-1) <= Distance3D(k) 
                if Distance3D(k) < min(Distance3D) + (j)*intervalWidth
                        fprintf("j:%d\n 1:%d \n 2:%d\n 3:%d\n",j,min(Distance3D),Distance3D(k), min(Distance3D) + (j)*intervalWidth);
                        a(n, j) = a(n, j) + weight(k);
                        a(n+7, j) = a(n+7, j) + 1;
                        Residue(k, 2) = j;
 
                end
            end
        end
    end
    
    n = n + 1;
%  Residue = [, weight];
        
    output_file = fullfile(output_dir, partition_file(i));

    writematrix([Residue,weight], output_file);
end

writematrix(a, 'a1_827.xlsx');
