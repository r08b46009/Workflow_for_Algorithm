function main_with_function_helices_COM
ribosome = [];
prefix = '7L200';
ext = '.xlsx';
directory = 'mal3 A';
file = [directory '/' prefix ext];
disp(file);

    [data, name, sum] = xlsread(file);

    Sum = cell2table(sum);

    residue = string(Sum(:,1).sum1);
    X = string(Sum(:,2).sum2);
    Y = string(Sum(:,3).sum3);

    X = str2double(X);
    Y = str2double(Y);

    num = size(X,1);
    m = zeros(5, 1);
    disp(X(1,1));

    M1=zeros(num, 1);
    M2=zeros(num, 1);
    M3=zeros(num, 1);
    M4=zeros(num, 1);

    
    
    
 
    directory = '7l20-pdb-bundle1';

    prefix1 = 'CenterOfMass-';
    ext1 = '.xlsx';
    idx1 = num2str(1);
    file1 = [directory '/' prefix1 idx1 ext1];
    disp(file1);
    %resIdx = cat(1,resIdx,[xlsread(file, 'B:B')]);
    
    XX = [];
    YY = [];
    ZZ = [];
    IND = [];
    Weight = [];
    IND = cat(1,IND,[xlsread(file1, 'B:B')]);
    XX = cat(1,XX,[xlsread(file1, 'G:G')]);
    YY = cat(1,YY,[xlsread(file1, 'H:H')]);
    ZZ = cat(1,ZZ,[xlsread(file1, 'I:I')]);
    Weight = cat(1,Weight,[xlsread(file1, 'F:F')]);
    
    IND(isinf(IND)|isnan(IND)) = 0;
    XX(isinf(XX)|isnan(XX)) = 0;
    YY(isinf(YY)|isnan(YY)) = 0;
    ZZ(isinf(ZZ)|isnan(ZZ)) = 0;
    Weight(isinf(Weight)|isnan(Weight)) = 0;
    gap = IND(1,1) - 1;
    
        
        
        
        

    for i = 1 : num
    tic
         [x, y, z, weight] = COM_helix_function_new_new( X(i,1), Y(i,1));
            m = [x, y, z, weight];



            M1(i,1)=m(1,1);
            M2(i,1)=m(1,2);
            M3(i,1)=m(1,3);
            M4(i,1)=m(1,4);
            coordinate=[residue, M1, M2, M3, M4];
    toc             
    end

coordinate=[residue, M1, M2, M3, M4];
writematrix(coordinate,'7l20_test5.xlsx');
        

function [x, y, z, molecular_Weight] = COM_helix_function_new_new(start,ending)

all_X = 0;
all_Y = 0;
all_Z = 0;
length = ending-start+1;
molecular_Weight = 0;

    length = ending-start+1;
        for j = 1 : size(XX,1)
 %           if(j == size(XX,1))
 %           COM_helix_function_new(start+1,ending, directory)
 %       end

            ind = IND(j, 1);

            if(ind == start)

                for k = start : ending

                    all_X = all_X + XX(k-gap, 1)*Weight(k-gap, 1);
                    all_Y = all_Y + YY(k-gap, 1)*Weight(k-gap, 1);
                    all_Z = all_Z + ZZ(k-gap, 1)*Weight(k-gap, 1);
                    molecular_Weight = molecular_Weight + Weight(k-gap, 1);    
                
                end
            end
                
        end
        
        x = all_X/molecular_Weight;
        y = all_Y/molecular_Weight;
        z = all_Z/molecular_Weight;





    disp(['x: ' convertStringsToChars(num2str(x))]);
    disp(['y: ' convertStringsToChars(num2str(y))]);
    disp(['z: ' convertStringsToChars(num2str(z))]);
    

        
end

end