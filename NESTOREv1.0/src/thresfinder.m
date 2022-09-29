function thresfinder(T,td, FEA, res_file, res_file2,FPR, TPR)
% Calculates the thresholds for every feature in the selected time intervals
% [t_start, t_end]. After the evalution, imposes th(j-i)<=th(j); if it does not
% happen, sets th(j-i)=th(j) going from t_end to ind_start. After t_end, sets the
% threshold to the value of t_end sets the threshold to NaN if TPR>FPR 

% Input:
% T         = time intervals (letters)
% td        = time intervals (number [days])
% FEA       = considered features names
% res_file  = first part of the name of the feature file
% res_file2 = first part of the name of the new feature file calculated in the good interval
% FPR       = false positive rate estimated by ROC10 
% TPR       = true  positive rate estimated by ROC10 
% Writes: thresholds file

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
% P. Brondi pbrondi@inogs.it
% License: GNUGPLv3
% last change May 6, 2022

fprintf('\n\nThis is thresfinder.m\n\n');

%Generates the thresholds file name
thresholds_file=fullfile('../data/Training_Output/',sprintf('Thresholds_M2_%s.txt',res_file2));

%vector of thresholds.
B=[];

%calculates the thresholds
for(i=1:length(T))
    filein=fullfile('../data/Training_Output/',sprintf('%s_%s.dat',res_file2,T{i}));
    thfea=thresfinder_ti(filein);
    B=[B;thfea];
end

% Uses the range table, corrects the thresholds's values and plots them.
% B should be NaN for td<t_start and equal to B(t_end) for td>t_end where 
% t_end is the time corresponding to maximum of informedness
range=fullfile('../data/Training_Output/',sprintf('range_M2_%s.dat',res_file));
C=load(range);


%RO=1 in the upper left corner on the ROC; RO=NaN in the bottom rigth one
RO=FPR*0+1;
RO(FPR>TPR)=NaN;



fid=fopen(thresholds_file,'w');



for(i=1:length(FEA))
    
    %sets to B=B(t_end) for td>t_end
    ind_end=find(td==C(i,2));
    th=B(:,i);
    %for times greater than the range sets threshold to the last value in
    %the range
    if(ind_end<length(th))
        for(j=ind_end+1:length(th))
            th(j)=B(ind_end,i);
        end
    end
    %eliminates values where the ROC gives unreliable results
    th=th.*RO(:,i);
    
   
    
    nonan=find(~isnan(th));
    if(~isempty(nonan))
        ind_start=nonan(1);
        %to be checked: imposes th(j-1)<=th(j)
        if(ind_end-ind_start>=1)
            for(j=ind_end:-1:ind_start+1)
                if(th(j-1)>th(j))
                    th(j-1)=th(j);
                end
            end
        end
        % end to be checked
        B(:,i)=th;

        %writes on file
        for(j=1:length(th))
            fprintf(fid,'%f ',th(j));
        end
        fprintf(fid,'\n');
    else
        for(j=1:length(th))
            fprintf(fid,'NaN ');
        end
        fprintf(fid,'\n');
    end
    
    
end

fclose(fid);


