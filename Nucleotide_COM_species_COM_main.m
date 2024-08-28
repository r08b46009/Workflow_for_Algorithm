temp = 0;
numIntervals = 0;
distance3D = 0;

species = ["new_Drosophila_correct.xlsx";
    "new_ecoli.xlsx";
    "new_haloa.xlsx";
    "new_human.xlsx";
    "new_mito.xlsx";
    "new_thermo.xlsx";
    "new_yeast.xlsx"];

output = ["distance_of_Drosophila_correct.xlsx";
    "distance_of_ecoli.xlsx";
    "distance_of_haloa.xlsx";
    "distance_of_human.xlsx";
    "distance_of_mito.xlsx";
    "distance_of_thermo.xlsx";    
    "distance_of_yeast.xlsx"];

% 文件路径列表

files = {'4v6w-pdb-bundle3.txt', ...
         '4v9d-pdb-bundle3.txt', ...
         '1jj2.pdb.txt', ...
         '4v6x-pdb-bundle3.txt', ...
         '7l20-pdb-bundle1.txt', ...
         '4v51-pdb-bundle4.txt', ...
         '4v88-pdb-bundle4.txt'};


% 初始化空矩阵
species_COM_coordinate = [];
X = [];
Y = [];
Z = [];
% 迭代读取每个文件，提取质心坐标
for i = 1:length(files)
    % 读取文件内容
    file_content = fileread(files{i});
    
    % 使用正则表达式提取质心坐标
    tokens = regexp(file_content, 'X:\s*(-?\d+\.\d+)\s*Y:\s*(-?\d+\.\d+)\s*Z:\s*(-?\d+\.\d+)', 'tokens');
    
    if ~isempty(tokens) % 检查提取是否成功
        % 将提取的坐标转换为数值数组，并添加到矩阵中
        centroid_coords = [str2double(tokens{1}{1}), str2double(tokens{1}{2}), str2double(tokens{1}{3})];
        
        % 检查数组维度是否为 1x3
        if length(centroid_coords) == 3
            species_COM_coordinate = [species_COM_coordinate; centroid_coords];
        else
            warning('Skipping file %s: extracted coordinates are not 1x3.', files{i});
        end
    else
        warning('No valid centroid coordinates found in file %s.', files{i});
    end
end

% 显示最终的矩阵
disp('species_COM_coordinate Matrix:');
disp(species_COM_coordinate);

% species_COM_coordinate = [30.3061 -24.6233 -6.9909;
% -32.2422 137.5850 161.3723;
% 65.16 124.8867 82.3292;
% 30.727 -29.3609 -11.6249; 
% 213.8745 205.4023 223.3208;
% -71.5117 -55.2496 23.1528;
% 36.6134 1.5657 75.1888];

input_dir = 'COM_files'; % 输入文件所在的目录
output_dir = 'Distance'; % 输出文件所在的目录


if ~exist(output_dir, 'dir')
    mkdir(output_dir); % 如果输出目录不存在，则创建
end


 for i = 1: numel(species)
     if isfile(output{i})
         delete(output{i});
     end

     file = fullfile(input_dir, species(i));
     
     [temp,numIntervals, distance3D ] = Nucleotide_COM_species_COM( file,  species_COM_coordinate(i, 1), species_COM_coordinate(i, 2), species_COM_coordinate(i, 3));
     outfile =fullfile(output_dir, output(i));
     writematrix(distance3D, outfile);
 
 end
