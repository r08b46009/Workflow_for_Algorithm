% 已排序文件的列表
species = {
    'sorted_files/4v6w-pdb-bundle3_new_sorted.xlsx',
    'sorted_files/4v9d-pdb-bundle3_new_sorted.xlsx',
    'sorted_files/1jj2_new_sorted.xlsx',
    'sorted_files/4v6x-pdb-bundle3_new_sorted.xlsx',
    'sorted_files/4v88-pdb-bundle4_new_sorted.xlsx',
    'sorted_files/7l20-pdb-bundle1_new_sorted.xlsx',
    'sorted_files/4v51-pdb-bundle4_new_sorted.xlsx',
};

% 对应的输出文件列表
output = {
    'COM_files/new_Drosophila_correct.xlsx',
    'COM_files/new_ecoli.xlsx',
    'COM_files/new_haloa.xlsx',
    'COM_files/new_human.xlsx',
    'COM_files/new_yeast.xlsx',
    'COM_files/new_mito.xlsx',
    'COM_files/new_thermo.xlsx'
};

% 如果文件夹不存在，则创建
if ~exist('COM_files', 'dir')
    mkdir('COM_files');
end

for i = 1:7
    kk =1;
    file = species{i};  % 使用花括号访问 cell 数组中的字符向量
    disp(['Reading ' file]);

    % 读取数据
    [data, name, sum] = xlsread(char(file));
    Sum = cell2table(sum);

    % 初始化变量
    resName = string(Sum{:, 1});  % 使用花括号获取表格内容
    X = str2double(Sum{:, 2});
    Y = str2double(Sum{:, 3});
    Z = str2double(Sum{:, 4});
    weight = str2double(Sum{:, 5});

    % 初始化聚合后的结果数组
    n = numel(X);
    resname = strings(n, 1);
    x = zeros(n, 1);
    y = zeros(n, 1);
    z = zeros(n, 1);
    Weight = zeros(n, 1);

    k = 0;  % 用于跟踪被合并条目数量
% 处理第一个数据点，避免越界问题
    if n > 1 && strcmp(resName(1), resName(2))
        
        if all(~isnan([X(1), Y(1), Z(1)])) && all(~isnan([X(2), Y(2), Z(2)])) && weight(1) > 0 && weight(2) > 0
            resName(1) = resName(1);
            X(1) = (X(1) * weight(1) + X(2) * weight(2)) / (weight(1) + weight(2));
            Y(1) = (Y(1) * weight(1) + Y(2) * weight(2)) / (weight(1) + weight(2));
            Z(1) = (Z(1) * weight(1) + Z(2) * weight(2)) / (weight(1) + weight(2));
            weight(1) = weight(1) + weight(2);
            kk = kk+1;
%             fprintf("1");
        else
            if any(isnan([X(1), Y(1), Z(1)]))
                if isnan(X(1)) || isnan(Y(1)) || isnan(Z(1))
%                     fprintf("1");
                    resName(1) = resName(2);
                    X(1) = X(2);
                    Y(1) = Y(2);
                    Z(1) = Z(2);
                    weight(1) = weight(2);
                    kk = kk+1;
                else
                    resName(1) = resName(1);
                    X(1) = X(1);
                    Y(1) = Y(1);
                    Z(1) = Z(1);
                    weight(1) = weight(1); 
                    kk = kk+1;
                end
%             k = 1;
            end
        
        end
    else
        if any(isnan([X(1), Y(1), Z(1)]))

            fprintf("1");
    
        else
            resName(1) = resName(1);        
            X(1) = X(1);
            Y(1) = Y(1);
            Z(1) = Z(1);
            weight(1) = weight(1);
            kk = kk+1;
        end
    end
    
    % 处理第2到倒数第2个数据点

    for j = 2:n-1
        if strcmp(resName(j), resName(j+1))
            
            if all(~isnan([X(j), Y(j), Z(j)])) && all(~isnan([X(j+1), Y(j+1), Z(j+1)])) && weight(j) > 0 && weight(j+1) > 0
                resName(kk) = resName(j);
                X(kk) = (X(j) * weight(j) + X(j+1) * weight(j+1)) / (weight(j) + weight(j+1));
                Y(kk) = (Y(j) * weight(j) + Y(j+1) * weight(j+1)) / (weight(j) + weight(j+1));
                Z(kk) = (Z(j) * weight(j) + Z(j+1) * weight(j+1)) / (weight(j) + weight(j+1));
                weight(kk) = weight(j) + weight(j+1);
                fprintf("%d %s 1\n", kk,resName(j));
                kk = kk+1;
            else
                if isnan(X(j)) && isnan(X(j+1))

                elseif any(isnan([X(j), Y(j), Z(j)]))
                    resName(kk) = resName(j+1);
                    X(kk) = X(j+1);
                    Y(kk) = Y(j+1);
                    Z(kk) = Z(j+1);
                    weight(kk) = weight(j+1);
                    fprintf("%d %s2\n", kk,resName(j));
                    kk = kk+1;

                else
                    resName(kk) = resName(j);
                    X(kk) = X(j);
                    Y(kk) = Y(j);
                    Z(kk) = Z(j);
                    weight(kk) = weight(j);
                    fprintf("%d %s3\n", kk,resName(j));
                    kk = kk+1;

                end
            end
        
        elseif strcmp(resName(j-1), resName(j)) == 1

            continue;
        else
            if any(isnan([X(j), Y(j), Z(j)]))
%                 k = k + 1;
            else
                resName(kk) = resName(j);
                X(kk) = X(j);
                Y(kk) = Y(j);
                Z(kk) = Z(j);
                weight(kk) = weight(j);
                fprintf("%d %s 4\n", kk,resName(j));
                kk = kk+1;

            end
%        
        end
    end
    
    % 处理最后一个数据点
    if n > 1
        if any(~isnan([X(n), Y(n), Z(n)])) && strcmp(resName(n-1), resName(n)) == 0
            resName(n-k) = resName(n);        
            X(kk) = X(n);
            Y(kk) = Y(n);
            Z(kk) = Z(n);
            weight(kk) = weight(n); 
            fprintf("%d %s5\n", kk,resName(n));
            kk = kk+1;

        else

        end
    end
    kk = kk-1;
    % 去除未使用的数组元素
    resName = resName(1:kk);
    X = X(1:kk);
    Y = Y(1:kk);
    Z = Z(1:kk);
    weight = weight(1:kk);
    
    % 将聚合后的数据写入 Excel 文件
    T1 = [resName, X, Y, Z, weight];
    writematrix(T1, output{i});
end
  

