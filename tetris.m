close all
%uint16() x;

[x,fs] = audioread('E:\24bit.wav','native');

x=x(1:2^16);
a=ones(2^16,1);

%sound(x,fs);

for(i=1:length(x))
  if(x(i)<0)
    a(i,1)=abs(x(i));
    a(i,1)=uint32(a(i,1));
    a(i,1)= 2^16 - a(i,1);
 else
    a(i,1) = x(i);
    end
end

a=dec2hex(a);

%fid = fopen('F:\data.txt', 'wt'); % открыли файл для записи
save data.txt a;

%fprintf(fid,'%s\r\n',a);
%fprintf(fid, '%s', a);
%fclose(fid);

%xlswrite('F:\tetris.xlsx',a);
