function perf_loo_ti(res_file, kmeans_file,pre_file,rec_file,acc_file,inform_file,mark_file,cm_file)
% Evaluates the performance of the features by the LOO method at a 
% T(i) reported in the res_file name and writes in the performances files

% Input
% res_file        = features file  name
% kmeans_file     = kmeans file name
% pre_file        = Precision file name
% rec_file        = Recall file name
% acc_file        = Accuracy file name
% inform_file     = Informedness file name
% mark_file       = Markedness file name 
% cm_file         = Confusion Matrix file name 

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% S. Gentili, sgentili@inogs.it 
% English comments and variable naming by P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change Jun 14, 2022


%fprintf('\n\nThis is perf_loo_ti\n\n');


fid_kmeans=fopen(kmeans_file,'a+');
fid_pre=fopen(pre_file,'a+');
fid_rec=fopen(rec_file,'a+');
fid_acc=fopen(acc_file,'a+');
fid_inf=fopen(inform_file,'a+');
fid_mark=fopen(mark_file,'a+');
fid_cm=fopen(cm_file,'a+');

A='A';
B='B';

%res_file=fullfile('../data/Training_Output/',res_file);

[Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor] = textread(res_file,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d');

FEA=[zeros(length(N),1),N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor];
C = {'constant', 'N','S','Z','SLcum','QLcum','SLcum2','QLcum2','Q','Vm','Vmed','Vn','N2','Nfor'};

[~,v]=size(FEA);

%cicle on the features
for(i=1:v)  
    fas=FEA(:,i);
    string_fea=C{i}; 
    % Performances are evaluated only if there aren't NaN;
    if(sum(isnan(fas))==0)
        
        [er,pre,re,acc,cm]=perf_loo_ti_fea(fas,ty);

        fprintf('Error on feature %s: %f\n',string_fea, mean(er));
        fprintf(fid_kmeans, '%f %f ',mean(er),std(er));
        fprintf(fid_pre, '%f %f ',mean(pre),std(pre));
        fprintf(fid_rec, '%f %f ',mean(re),std(re));
        fprintf(fid_acc, '%f %f ',mean(acc),std(acc));
        [results,~] = bookmaker(cm);
        fprintf(fid_inf, '%f 0 ', results.bookmaker);
        fprintf(fid_mark, '%f 0 ', results.markedness);
        fprintf(fid_cm, '%f %f %f %f ', cm(1,1),cm(1,2),cm(2,1),cm(2,2));
    else
        fprintf('Error on feature %s: NaN\n',string_fea);
        fprintf(fid_kmeans, 'NaN NaN ');
        fprintf(fid_pre, 'NaN NaN ');
        fprintf(fid_rec, 'NaN NaN ');
        fprintf(fid_acc, 'NaN NaN ');       
        fprintf(fid_inf, 'NaN 0 ');
        fprintf(fid_mark, 'NaN 0 ');
        fprintf(fid_cm, 'NaN NaN NaN NaN ');
    end
end




fprintf(fid_kmeans,'\n');
fprintf(fid_pre,'\n');
fprintf(fid_rec,'\n');
fprintf(fid_acc,'\n');
fprintf(fid_inf,'\n');
fprintf(fid_mark,'\n');
fprintf(fid_cm,'\n');
fclose(fid_kmeans);
fclose(fid_pre);
fclose(fid_rec);
fclose(fid_acc);
fclose(fid_inf);
fclose(fid_mark);
fclose(fid_cm);





