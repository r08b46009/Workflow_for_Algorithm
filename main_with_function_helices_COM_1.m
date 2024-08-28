function main_with_function_helices_COM_1

% 定义7组输入文件和对应的目录
prefixes = {'7l20-pdb-bundle1', '4v88-pdb-bundle4', '4v51-pdb-bundle4', '4v9d-pdb-bundle3', ...
            '4v6x-pdb-bundle3', '4v6w-pdb-bundle3', '1jj2'};
raw_dir = 'input'; % CSV 文件所在的目录
bundle_dir = 'bundle'; % XLSX 文件所在的目录
output_dir = 'new'; % 设置输出文件的目录

if ~exist(output_dir, 'dir')
    mkdir(output_dir); % 如果文件夹不存在，则创建
end

global XX YY ZZ Weight IND gap; % 声明全局变量

for p = 1:length(prefixes)

    prefix = prefixes{p};
    csv_file = fullfile(raw_dir, [prefix '.xlsx']);
    xlsx_file = fullfile(bundle_dir, prefix, 'CenterOfMass-1.xlsx'); % 修改以适应你的XLSX文件结构

    disp(['Processing: ', csv_file, ' and ', xlsx_file]);

    % 读取 CSV 文件
    [data, name, sum] = xlsread(csv_file);
    Sum = cell2table(sum);

    residue = string(Sum(:,1).sum1);
    X = string(Sum(:,2).sum2);
    Y = string(Sum(:,3).sum3);

    X = str2double(X);
    Y = str2double(Y);

    num = size(X,1);
    fprintf('num:%d, %d', num, p);
    m = zeros(5, 1);

    M1 = zeros(num, 1);
    M2 = zeros(num, 1);
    M3 = zeros(num, 1);
    M4 = zeros(num, 1);

    % 读取 XLSX 文件中的数据
    IND = [];
    XX = [];
    YY = [];
    ZZ = [];
    Weight = [];

    IND = cat(1, IND, xlsread(xlsx_file, 'B:B'));
    XX = cat(1, XX, xlsread(xlsx_file, 'G:G'));
    YY = cat(1, YY, xlsread(xlsx_file, 'H:H'));
    ZZ = cat(1, ZZ, xlsread(xlsx_file, 'I:I'));
    Weight = cat(1, Weight, xlsread(xlsx_file, 'F:F'));

    IND(isinf(IND) | isnan(IND)) = 0;
    XX(isinf(XX) | isnan(XX)) = 0;
    YY(isinf(YY) | isnan(YY)) = 0;
    ZZ(isinf(ZZ) | isnan(ZZ)) = 0;
    Weight(isinf(Weight) | isnan(Weight)) = 0;
    gap = IND(1,1) - 1;

    % 处理每个残基的质心计算
    for i = 1 : num
        tic
        fprintf("%d, %d\n", X(i,1), Y(i,1));
        [x, y, z, weight] = COM_helix_function_new_new(X(i,1), Y(i,1), prefix);
        m = [x, y, z, weight];
        fprintf("%d, %d, %d, %d\n", x, y, z, weight);
        M1(i,1) = m(1,1);
        M2(i,1) = m(1,2);
        M3(i,1) = m(1,3);
        M4(i,1) = m(1,4);

        toc             
    end

    % 将结果保存到新的 XLSX 文件中
    coordinate = [residue, M1, M2, M3, M4];
    output_file = fullfile(output_dir, [prefix '_new.xlsx']);

    writematrix(coordinate, output_file);
    disp(['Output saved to: ', output_file]);

end

end
function [x, y, z, molecular_Weight] = COM_helix_function_new_new(start, ending, prefix)
    global XX YY ZZ Weight IND gap; % 声明全局变量

    all_X = 0;
    all_Y = 0;
    all_Z = 0;
    molecular_Weight = 0;

    for j = 1 : size(XX,1)
        ind = IND(j, 1);

        if ind == start
            for k = start : ending
                idx = k - gap; % 计算索引
                
                % 检查索引是否在合法范围内
                if idx > 0 && idx <= size(XX, 1)
                    all_X = all_X + XX(idx, 1) * Weight(idx, 1);
                    all_Y = all_Y + YY(idx, 1) * Weight(idx, 1);
                    all_Z = all_Z + ZZ(idx, 1) * Weight(idx, 1);
                    molecular_Weight = molecular_Weight + Weight(idx, 1);
                else
                    warning('Index %d out of bounds for XX, YY, ZZ or Weight arrays.', idx);
                    fprintf('%s',prefix);
                end
            end
        end
    end

    % 计算质心
    if molecular_Weight ~= 0
        x = all_X / molecular_Weight;
        y = all_Y / molecular_Weight;
        z = all_Z / molecular_Weight;
    else
        x = NaN; y = NaN; z = NaN;

        warning('Molecular weight is zero, cannot compute centroid.');
        fprintf('%s',prefix);
    end

    disp(['x: ', num2str(x)]);
    disp(['y: ', num2str(y)]);
    disp(['z: ', num2str(z)]);
end
