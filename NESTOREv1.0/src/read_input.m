
%current directory
hodi = cd;
% set some of the paths 
fs = filesep;
addpath([hodi fs 'external' fs], [hodi fs 'external' fs 'Bookmaker' fs],[hodi fs 'external' fs 'filetime' fs]);


user_input;
NESTORE_par;

% Time intervals (characters [days])
T=cell(1,length(td));
    
for(i=1:length(td))
    if(td(i)<1)
        T{1,i}=sprintf('%dh',round(td(i)*24));
    else
        T{1,i}=sprintf('%dd',td(i));
    end
end


kk = strfind(res_file,'_no_stop_');

% Feature file name in the second run containing 'res_stop' string. It 
% corresponds to features calculated for time periods of good performances
% "good interval"
res_file2=sprintf('%s_stop_%s',res_file(1:kk-1),res_file(kk+9:end));



%INVESTIGATED AREA 
PL=load(Po_file);

