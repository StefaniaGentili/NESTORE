function class_perf_ti(class_file,pre_file,re_file,acc_file,inf_file,cm_file)
% file_perf_ev_class(class_file,  pre, re, acc, inform,cm);
% given the input classification file, writes the performances in the corresponding 
% files in terms of precision, recall, accuracy, informedness and confusion
% matrix

% class_file = classification file
% pre_file  = precision file
% re_file   = recall file
% acc_file  = accuracy file
% inf_file  = informedness file
% cm_file   = confusion matrix file


%Calls class_perf_ti_fea


% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.


% S. Gentili, sgentili@ogs.it
% License: GNUGPLv3
% last update: June 22, 2022

pre_fid=fopen(pre_file,'a+');
re_fid=fopen(re_file,'a+');
acc_fid=fopen(acc_file,'a+');
inf_fid=fopen(inf_file,'a+');
cm_fid=fopen(cm_file,'a+');

A='A';
B='B';


%reads it
[Date,Time,ML,Lat,Lon,Depth,Naft,Maft,Dateaft,Timeaft,Lataft,Lonaft,Depthaft,Dt,ty,Mc,dMc,N,S,Z,SLcum,QLcum,SLcum2,QLcum2,Q,Vm,Vmed,Vn,N2,Nfor,P_S,C_S,P_Z,C_Z,P_SLcum,C_SLcum,P_QLcum,C_QLcum,P_SLcum2,C_SLcum2,P_QLcum2,C_QLcum2,P_Q,C_Q,P_Vm,C_Vm,P_N2,C_N2,P_A_Bayes,C_Bayes,numB,numA,Class_simp] = textread(class_file,'%s %s %f %f %f %d %d %f %s %s %f %f %d %f %s %f %f %d %f %f %f %f %f %f %f %f %f %f %f %d %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %d %d %s', 'headerlines',1);


CFEA=[C_S,C_Z,C_SLcum,C_QLcum,C_SLcum2,C_QLcum2,C_Q,C_Vm,C_N2,C_Bayes,Class_simp];

[~,v]=size(CFEA);

%for each feature, comparing the true class and NESTORE classification for 
%the patterns in the test set, estimates the performances and writes them 
%in the corresponding file
for(i=1:v)
    typeP=CFEA(:,i);

    [pre,re,acc,infor, cm]=class_perf_ti_fea(ty,typeP);
    
    fprintf(pre_fid, '%f 0 ',pre);
    fprintf(re_fid, '%f 0 ',re);
    fprintf(acc_fid, '%f 0 ',acc); 
    fprintf(inf_fid, '%f 0 ', infor);
    fprintf(cm_fid, '%f %f %f %f ', cm(1,1),cm(1,2),cm(2,1),cm(2,2));
end


fprintf(pre_fid,'\n');
fprintf(re_fid,'\n');
fprintf(acc_fid,'\n');
fprintf(inf_fid,'\n');
fprintf(cm_fid,'\n');
fclose(pre_fid);
fclose(re_fid);
fclose(acc_fid);
fclose(inf_fid);
fclose(cm_fid);





