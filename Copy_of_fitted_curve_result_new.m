
%y=[1,4,9,6,11,13,14,11,9,9,6,5,5,2,2,2,1];

[data, name, s] = xlsread('a1_new_test4.xlsx');
%[data, name, s] = xlsread('a1_new_test3.xlsx');

Sum = cell2table(s);

nnum = [18, 15, 14, 18, 14 ,12, 16];
%nnum = [18, 15, 14, 19, 21 ,12, 16];

nn = 1;

%["Drosophila correct.xlsx";
%    "ecolifit";
%    "haloafit";
%    "humanfit";
%    "yeastfit"]

% frequency = table2array(Sum(nn+5,1:nnum(1,nn)));
% x = [1:nnum(1, nn)];
% bin = [1:nnum(1, nn)];

frequency = table2array(Sum(nn+7,1:nnum(1,nn)));

x = [1:nnum(1, nn)];
%x = x - nnum(1, nn)/2;
bin = [1:nnum(1, nn)];
%bin = bin - nnum(1, nn)/2;

%gaussEqn = '(1/2a)*exp(-((x-b)/a))';
%startPoints = [max(frequency),mean(frequency),std(frequency),1];
%gaussEqn = 'a*exp(-(abs(x-b)/c))+d';
startPoints = [10,mean(frequency),12,1];
gaussEqn = 'exp(-(abs(x-b)/c))+d';

%gaussEqn = 'a*exp(-(abs(x-b)/c))+d';
%gaussEqn =  'a*exp(-((x-b)/c)^2)+d'; 
%startPoints = [1,1,1,1];
f1 = fit(bin',frequency',gaussEqn,'start', startPoints);
plot(f1,bin,frequency)

ylabel('frequency');
xlabel('bin');
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
%title('A Helix Distribution of mtRNA from Human', 'FontSize', 15);
legend('frequency', 'Laplacian distribution')
exportgraphics(gcf,'s.pdf')
%aaa=f1.a;

bbb=f1.b;
ccc=f1.c;
ddd=f1.d;
y2 = exp(-(abs(x-bbb)/ccc))+ddd; 
%y2 = aaa*exp(-(abs(x-bbb)/ccc))+ddd; 

disp(max(y2));

A=frequency-y2;
disp((aaa+ddd)-max(y2));

B=A.^2;
%C=sum(B);
fprintf('12344')
fprintf('Height %s  Average %d  STD %c D %a  \n',aaa,bbb,ccc,ddd);

%fprintf('誤差平方和 = %d\n', sum((frequency-y2).^2));