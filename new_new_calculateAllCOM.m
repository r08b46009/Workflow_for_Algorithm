function [CenterOfMass, A] = new_new_calculateAllCOM(fileName, chain_ID, output_folder)
    fileName = convertStringsToChars(fileName);
    fprintf('Reading %s for chain ID %s, outputting to %s\n', fileName, chain_ID, output_folder);

    pdb = pdbread(fileName);

    % 根據傳遞的 output_folder 參數設置輸出子資料夾
    [~, name, ~] = fileparts(fileName);
    output_subfolder = fullfile(output_folder, name);

    if ~exist(output_subfolder, 'dir')
        mkdir(output_subfolder);
    end

    Atom = [pdb.Model.Atom];
    cc = struct2table(Atom);
    num_of_atom = numel(cc.chainID);

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

    i = 1;
    X = [];
    Y = [];
    Z = [];
    element = [];
    resSeq = [];
    resName = [];

    % 過濾指定鏈的原子
    while(i <= num_of_atom)
        if(strcmp(cc.chainID(i), chain_ID))
            X(end+1) = cc.X(i);
            Y(end+1) = cc.Y(i);
            Z(end+1) = cc.Z(i);
            element{end+1} = cc.element{i};
            resSeq(end+1) = cc.resSeq(i);
            resName{end+1} = cc.resName{i};
        end
        i = i + 1;
    end

    % Debugging Information
    fprintf('Number of atoms after filtering: %d\n', length(X));
    disp('resSeq:');
    disp(resSeq);
    disp('resName:');
    disp(resName);

    if isempty(X)
        warning('No atoms found for chain ID %s in file %s\n', chain_ID, fileName);
        return;
    end

    resIdx = resSeq(1);
    offset = resIdx - 1;
    fileIdx = 1;

    % 計算質心
    i = 1;
    while(i <= length(resSeq))  % 修改循环条件
        j = i;
        totalWeight = 0;
        atomWeight = 0;
        count = 0;
        weightX = 0;
        weightY = 0;
        weightZ = 0;

        while(j <= length(resSeq) && resIdx == resSeq(j))  % 确保 j 在有效范围内
            if strcmp(element{j}, 'C')
                atomWeight = C;
            elseif strcmp(element{j}, 'N')
                atomWeight = N;
            elseif strcmp(element{j}, 'O')
                atomWeight = O;
            elseif strcmp(element{j}, 'P')
                atomWeight = P;
            elseif strcmp(element{j}, 'S')
                atomWeight = S;
            end

            weightX = weightX + X(j) * atomWeight;
            weightY = weightY + Y(j) * atomWeight;
            weightZ = weightZ + Z(j) * atomWeight;
            totalWeight = totalWeight + atomWeight;
            count = count + 1;
            j = j + 1;
        end

        % Debugging Information
        fprintf('Processing residue index: %d, Total Weight: %.2f\n', resIdx, totalWeight);

        if resIdx > 0
            valid_idx = resIdx - offset;
            if valid_idx > 0
                COT(valid_idx).resName = resName{i};
                COT(valid_idx).resIdx = resIdx;
                COT(valid_idx).weightX = weightX;
                COT(valid_idx).weightY = weightY;
                COT(valid_idx).weightZ = weightZ;
                COT(valid_idx).totalWeight = totalWeight;
                if totalWeight ~= 0
                    COT(valid_idx).COMX = weightX / totalWeight;
                    COT(valid_idx).COMY = weightY / totalWeight;
                    COT(valid_idx).COMZ = weightZ / totalWeight;
                else
                    COT(valid_idx).COMX = 0;
                    COT(valid_idx).COMY = 0;
                    COT(valid_idx).COMZ = 0;
                end
                COT(valid_idx).count = j - i;
            else
                warning('Invalid index %d for residue index %d\n', valid_idx, resIdx);
            end
        end

        if j <= length(resSeq)
            resIdx = resSeq(j);  % 更新 resIdx
        end
        i = j;  % 移动到下一个残基
    end

    saveCOMtoXLSX(COT, fileIdx, output_subfolder);
    CenterOfMass = COT;
    A = pdb.Model.Atom;
end

function [] = saveCOMtoXLSX(COMdata, fileIdx, output_subfolder)
    prefix = 'CenterOfMass-';
    ext = '.xlsx';
    filenum = num2str(fileIdx);
    cotfile = fullfile(output_subfolder, [prefix filenum ext]);
    writetable(struct2table(COMdata), cotfile);
end
