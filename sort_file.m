% 文件列表
files = {
    '1jj2_new.xlsx',
    '4v6w-pdb-bundle3_new.xlsx',
    '4v6x-pdb-bundle3_new.xlsx',
    '4v9d-pdb-bundle3_new.xlsx',
    '4v51-pdb-bundle4_new.xlsx',
    '4v88-pdb-bundle4_new.xlsx',
    '7l20-pdb-bundle1_new.xlsx'
};

input_dir = 'new'; % 输入文件的目录
output_dir = 'sorted_files'; % 输出文件的目录

if ~exist(output_dir, 'dir')
    mkdir(output_dir); % 如果输出目录不存在，则创建
end

% 遍历每个文件
for i = 1:length(files)
    input_file = fullfile(input_dir, files{i});
    
    % 读取 Excel 文件
    [data, txt, raw] = xlsread(input_file);
    
    % 提取第一列
    column_to_sort = raw(:, 1); % 提取第一列
    
    % 初始化两个数组来分别存储数值和字符
    numeric_values = [];
    string_values = {};
    numeric_indices = [];
    string_indices = [];
    
    % 检查每个元素的类型并分类
    for j = 1:length(column_to_sort)
        if isnumeric(column_to_sort{j}) && ~isnan(column_to_sort{j})
            numeric_values = [numeric_values; column_to_sort{j}];
            numeric_indices = [numeric_indices; j];
        elseif ischar(column_to_sort{j})
            string_values = [string_values; column_to_sort{j}];
            string_indices = [string_indices; j];
        end
    end
    
    % 对字符和数值分别排序
    [sorted_numeric_values, numeric_sortIdx] = sort(numeric_values);
    [sorted_string_values, string_sortIdx] = sort(string_values);
    
    % 重新构建排序后的索引
    sortIdx = [numeric_indices(numeric_sortIdx); string_indices(string_sortIdx)];
    
    % 根据排序后的索引对整个表格进行排序
    sorted_raw = raw(sortIdx, :);
    
    % 将 cell 数组转换为表格 (table)
    sorted_table = cell2table(sorted_raw);
    
    % 将排序后的数据保存到一个新的文件中
    [~, name, ext] = fileparts(files{i});
    output_file = fullfile(output_dir, [name '_sorted' ext]);
    writetable(sorted_table, output_file);
    
    disp(['Data from ' files{i} ' sorted and saved to: ' output_file]);
end
