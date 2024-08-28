% Main Workflow Script: script_for_evolution_algorithm.m

% 定義存放 PDB 檔案的資料夾路徑
% pdb_folder = '/pdbs/';   % 請替換為實際的資料夾路徑

% 定義所有需要處理的 PDB 檔案、對應的輸出檔案名稱及其鏈 ID
pdb_files = {
    '4v9d-pdb-bundle3.pdb', '4v9d-pdb-bundle3.txt', 'E';
    '4v51-pdb-bundle4.pdb', '4v51-pdb-bundle4.txt', 'A';
    '1jj2.pdb', '1jj2.pdb.txt', '0';
    '4v88-pdb-bundle4.pdb', '4v88-pdb-bundle4.txt', 'K';
    '4v6x-pdb-bundle3.pdb', '4v6x-pdb-bundle3.txt', 'A';
    '4v6w-pdb-bundle3.pdb', '4v6w-pdb-bundle3.txt', 'A';
    '7l20-pdb-bundle1.pdb', '7l20-pdb-bundle1.txt', 'A'
};

% 迭代處理每個 PDB 檔案
for i = 1:size(pdb_files, 1)
    pdb_filename = pdb_files{i, 1};
    output_filename = pdb_files{i, 2};
    chain_ID = pdb_files{i, 3};  % 取得對應的 chain ID
    pdb_folder = 'pdbs';  % 替換為你的資料夾路徑
    % 組合完整的檔案路徑
    full_pdb_path = fullfile(pdb_folder, pdb_filename);

%     pdb_folder = 'pdbs';  % 替換為你的資料夾路徑
    files_in_folder = dir(pdb_folder);
    
    % 列出資料夾中的所有檔案
    disp({files_in_folder.name});

    disp(['Processing ' full_pdb_path ' with chain ID ' chain_ID '...']);
    
    % 呼叫 calculate_COM 函式並傳遞參數
    calculate_COM(full_pdb_path, chain_ID, output_filename);
    
    disp(['Output saved to ' output_filename]);

end

%Step2_Calculate_ALL_COM

pdb_files = {
    '1jj2.pdb', '0';
    '4v6w-pdb-bundle3.pdb', 'A';
    '4v6x-pdb-bundle3.pdb', 'A';
    '4v9d-pdb-bundle3.pdb', 'E';
    '4v51-pdb-bundle4.pdb', 'A';
    '4v88-pdb-bundle4.pdb', 'K';
    '7l20-pdb-bundle1.pdb', 'A'
};

% 定義PDB檔案所在的資料夾
pdb_folder = 'pdbs';

% 定義bundle資料夾作為輸出資料夾
output_folder = 'bundle';
files_in_folder = dir(pdb_folder);
%     
%列出資料夾中的所有檔案
%     disp({files_in_folder.name});
% 確保輸出資料夾存在，若不存在則創建
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% % % %     % 迭代處理每個PDB檔案
for i = 1:size(pdb_files, 1)
    pdb_filename = pdb_files{i, 1};
    chain_ID = pdb_files{i, 2};
    full_pdb_path = fullfile(pdb_folder, pdb_filename);
    fprintf(chain_ID);
    % 呼叫 new_new_calculateAllCOM 函數並保存結果到 bundle 資料夾
    [CenterOfMass, A] = new_new_calculateAllCOM(full_pdb_path, chain_ID, output_folder);
    disp(['Finished processing ' pdb_filename]);
end





main_with_function_helices_COM_main
sort_file;

new_COM_generator;
% 
Nucleotide_COM_species_COM_main;
partition_new;
fitted_curve_result_new_2;


disp('All files processed successfully.');
