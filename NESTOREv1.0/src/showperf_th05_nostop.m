function showperf_th05_nostop(td,FEA,k,res_file)
% Reads the performance files (estimators)and shows them. 
% It evaluates for each features the good interval (in days) in which:
% - the estimators are defined
% - estimators are greater than 0 (informedness) or 0.5 (all the others)
% - the accuracy is greater or equal to the one of the constant feature
% Writes a file range_file containing the start time of the good interval, the 
% time of maximum informedness, the end time of the good interval

% Input:
% td        = time intervals (number [days])
% FEA       = considered features names
% k         = position of the features in the estimator's files
% res_file  = first part of the name of the feature file

% Output: visualization of the results and range_file (extremes of the
% "good interval"

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
% last change November 9, 2021

fprintf('\n\nThis is showperf_th05_nostop\n\n');

%generates the names of the estimators
pre=fullfile('../data/Training_Output/',sprintf('pre_M2_%s.dat', res_file));
re=fullfile('../data/Training_Output/',sprintf('re_M2_%s.dat', res_file));
acc=fullfile('../data/Training_Output/',sprintf('acc_M2_%s.dat', res_file));
inform=fullfile('../data/Training_Output/',sprintf('inform_M2_%s.dat', res_file));
%generates the name of the range file
range_file=fullfile('../data/Training_Output/',sprintf('range_M2_%s.dat', res_file));




%shows the performances in terms of precision, recall, accuracy and
%Informedness of all features
showperf_th05_nostop_fig(pre,'Precision',FEA,td);
showperf_th05_nostop_fig(re,'Recall',FEA,td);
showperf_th05_nostop_fig(acc,'Accuracy',FEA,td);
showperf_th05_nostop_fig(inform,'Informedness',FEA,td);

%loads the estimators' files
PRE=load(pre);
RE=load(re);
ACC=load(acc);
INFOR=load(inform);


%for each feature separately, finds the good intervals; writes it on the
% file range_file

if(exist(range_file))
    delete(range_file);
end

fid=fopen(range_file, 'a+');

%cicle on features
for(j=1:length(FEA))
    % searches for indexes where the estimators are defined, greater than 0 
    % (informedness) or 0.5 (all the others)and the accuracy is greater 
    % than the one of the constant feature
    u=find(PRE(:,k(j))>0.5 & RE(:,k(j))>0.5 & ACC(:,k(j))>0.5 & INFOR(:,k(j))>0 & ACC(:,k(j))>=ACC(:,1));
    if(~isempty(u))
        %maximum of Informedness
        I=find(INFOR(u,k(j))==max(INFOR(u,k(j))));
        % note: if I corresponds to more than one index int stops at the 
        % first one 
        % int* are the indexes where using the features is allowed
        int=u(1:I(1));

 
        
        %if the interval ends before the end of the test periods, i.e. the
        %feature can be used for times greater than the one of maximum
        %informedness calculates the maximum usability period without holes.
        %This is end_int
        
        end_int=int(end);
        
        if(int(end)<u(end))
            du=diff(u(I(1):end));
            l=1;
            while(l<=length(du) & du(l)<2)
                end_int=int(end)+l;
                l=l+1;
            end
        end
        
        
        fprintf('feature %s defined in = [ %f %f ] days\n',FEA{j},td(int(1)), td(end_int));
        fprintf('maximum Informedness in %f days\n', td(int(end)));
        %writes in range_file the minimum of good interval, the informedness
        %maximum and the maximum of the good interval
        fprintf(fid, '%f %f %f\n', td(int(1)), td(int(end)), td(end_int));
    else
        fprintf('feature %s has not good interval\n',FEA{j});
        fprintf(fid, 'NaN NaN NaN\n');
    end
 
end
   

fclose(fid);

