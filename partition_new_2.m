 output = ["distance_of_Drosophila correct.xlsx";
     "distance_of_ecoli.xlsx";
     "distance_of_haloa.xlsx";
     "distance_of_human.xlsx";
     "distance_of_yeast.xlsx";
     "distance_of_mito.xlsx";
     "distance_of_thermo.xlsx";
 ]

 partition_file = ["partition_of_COM_of_Drosophila correct.xlsx";
     "partition_of_COM_of_ecoli.xlsx";
     "partition_of_COM_of_haloa.xlsx";
     "partition_of_COM_of_human.xlsx";
     "partition_of_COM_of_yeast.xlsx";
     "partition_of_COM_of_mito.xlsx";
     "partition_of_4v51_thermo.xlsx";
     
 ]







numIntervals = 17; 

n=1;

a = zeros(140);


lis = {};

for i = 1 : numel(output);

    
file =  output(i);

disp(['reading ' file]);

weight = [];

Distance3D = []; 



[data, name, sum] = xlsread(file);

Sum = cell2table(sum);


Distance3D = str2double(string(Sum(:,1).sum1));
weight = str2double(string(Sum(:,2).sum2));
residue = string(Sum(:,3).sum3);
Residue = string(Sum(:,3).sum3);



%weight = cat(1,weight,[xlsread(file, 'B:B')]);
%weight = table(:,2).distance3D2;
%Distance3D = cat(1,Distance3D,[xlsread(file, 'A:A')]);



intervalWidth = 7;
disp(intervalWidth);





 weight(isnan(weight)) = 0 ;

    for k = 1 : size(weight)
        
        mm=0 ;
         
        
            for j = 1 :   numIntervals+7
                
                deposit_residue = strings(1,numIntervals+7);

            
                if(min(Distance3D) + (j-1)*intervalWidth < max(Distance3D)) 
%                 
                    if ( min(Distance3D) + intervalWidth*(j-1)  <= Distance3D(k) && Distance3D(k) < min(Distance3D) + (j)*intervalWidth )
%                  if( (j-1)*intervalWidth < max(Distance3D)) 
%                 
%                     if(intervalWidth*(j-1)  <= Distance3D(k) && Distance3D(k) < min(Distance3D) + (j)*intervalWidth )                       
%                         
                        
                        a(n,j) = a(n,j) + weight(k);
                        
                        a( n+7,j ) = a(n+7,j) + 1;
                        
                        Residue(k,2)=j;
                        
                        
                   %     if( numel(lis(i,j,:)) ~= 0 )
                       
                   %     zz=zz+1;
                        
                   %     end
                        
                   %     push(lis(i,j), table(j,1).distance3D1);
                        
                    
                    end       
                    
                end
                
            end
        
    end
    
  %  zz=0
    n=n+1;
    Residue = [Residue, weight];
    writematrix(Residue, [partition_file(i)])
   
end


writematrix(a,'a1_new_test4.xlsx');




