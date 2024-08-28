[data, name, s] = xlsread('a1_827.xlsx');
Sum = cell2table(s);

nnum = [18, 15, 15, 19, 14 ,13, 16];
output_files = {

    'COM_files/new_Drosophila_correct.xlsx',
    'COM_files/new_ecoli.xlsx',
    'COM_files/new_haloa.xlsx',
    'COM_files/new_human.xlsx',
    'COM_files/new_yeast.xlsx',    
    'COM_files/new_mito.xlsx',
    'COM_files/new_thermo.xlsx'
};
    
for nn = 1:numel(nnum)
    % 在每次循环开始时重新初始化变量
    frequency = table2array(Sum(nn+7, 1:nnum(1, nn)));

    x = 1:nnum(1, nn);
    bin = 1:nnum(1, nn);
    startPoints = [28,7,7,0];
    gaussEqn = fittype('a*exp(-(abs(x-b)/c))+d');
    f1 = fit(bin', frequency', gaussEqn, 'Start', startPoints);

    % 绘图并保存为 PDF 文件
    figure;
    plot(f1, bin, frequency);
    ylabel('frequency');
    xlabel('bin');
    ax = gca;
    ax.XAxis.FontSize = 15;
    ax.YAxis.FontSize = 15;
    legend('frequency', 'Laplacian distribution');
    filename = sprintf('s_%d.pdf', nn);
    exportgraphics(gca, filename);
    close;

    % 提取拟合参数
    aaa = f1.a;
    bbb = f1.b;
    ccc = f1.c;
    ddd = f1.d;

    % 计算y2、A、B等变量并重置
    y2 = aaa * exp(-(abs(x-bbb)/ccc)) + ddd;
    
    A = frequency - y2;
    B = A.^2;

    % 打印结果
    fprintf('Output for file: %s\n', output_files{nn});
    fprintf('Height: %f  Average: %f  STD: %f  D: %f  NN: %d %s\n', aaa, bbb, ccc, ddd, nn, output_files{nn});

    % 保存到输出文件（如果需要的话）
    % writematrix([aaa, bbb, ccc, ddd], output_files{nn});
end