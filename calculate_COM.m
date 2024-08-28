function calculate_COM(pdb_filename, chain_ID, output_filename)
    % 讀取 PDB 檔案
    pdb = pdbread(pdb_filename);

    % 提取原子坐標和元素
    X = [pdb.Model.Atom.X];
    Y = [pdb.Model.Atom.Y];
    Z = [pdb.Model.Atom.Z];
    element = [pdb.Model.Atom.element];
    chainID = [pdb.Model.Atom.chainID];

    % 過濾指定鏈的原子
    X = X(chainID == chain_ID);
    Y = Y(chainID == chain_ID);
    Z = Z(chainID == chain_ID);

    % 計算質心
    num_of_atom = numel(X);
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

    for i = 1 : num_of_atom
        switch element(1, i)
            case 'C'
                factor = C;
            case 'N'
                factor = N;
            case 'O'
                factor = O;
            case 'P'
                factor = P;
            case 'S'
                factor = S;
            otherwise
                factor = 0; % 其他元素暫時不處理
        end
        norm = factor;
        normalizer = normalizer + norm;
        currentX = currentX + (X(1, i) * factor);
        currentY = currentY + (Y(1, i) * factor);
        currentZ = currentZ + (Z(1, i) * factor);
    end

    currentX = currentX / normalizer;
    currentY = currentY / normalizer;
    currentZ = currentZ / normalizer;

    % 儲存結果
    fid = fopen(output_filename, 'w');
    fprintf(fid, 'Centroid for chain %s:\n', chain_ID);
    fprintf(fid, 'X: %.4f\n', currentX);
    fprintf(fid, 'Y: %.4f\n', currentY);
    fprintf(fid, 'Z: %.4f\n', currentZ);
    fclose(fid);
end