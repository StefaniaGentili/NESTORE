function perf_loo_stop(T,res_file2)
% Evaluates the performances of the features in the selected "good interval"
% by a LOO method and one-node decision trees
% It calls perf_loo_ti for every time interval.

% Input:
% T         = time intervals (letters)
% res_file2  = first part of the name of the feature file calculated in the good interval

% Writes: files of precision, recall, accuracy, informedness, markedness,
% cm (confusion matrix) and performances for every cluster and time interval

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
% last change June 14, 2022

fprintf('\n\nThis is perf_loo_stop.m\n\n');

kmeans=fullfile('../data/Training_Output/',sprintf('kmeans_M2_stop_%s.dat', res_file2));
pre=fullfile('../data/Training_Output/',sprintf('pre_M2_stop_%s.dat', res_file2));
re=fullfile('../data/Training_Output/',sprintf('re_M2_stop_%s.dat', res_file2));
acc=fullfile('../data/Training_Output/',sprintf('acc_M2_stop_%s.dat', res_file2));
inform=fullfile('../data/Training_Output/',sprintf('inform_M2_stop_%s.dat', res_file2));
mark=fullfile('../data/Training_Output/',sprintf('mark_M2_stop_%s.dat', res_file2));
cm=fullfile('../data/Training_Output/',sprintf('cm_M2_stop_%s.dat', res_file2));
pe=fullfile('../data/Training_Output/',sprintf('perf_M2_stop_%s.dat', res_file2));

%eliminates already existing files
if(exist(kmeans))
    delete(kmeans);
end
if(exist(pre))
    delete(pre);
end
if(exist(re))
    delete(re);
end
if(exist(acc))
    delete(acc);
end
if(exist(inform))
    delete(inform);
end
if(exist(mark))
    delete(mark);
end
if(exist(cm))
    delete(cm);
end
%calls perf_loo_ti for every T(i)
for(i=1:length(T))
    %generates the feature file name for every time window
    filein=fullfile('../data/Training_Output/',sprintf('%s_%s.dat',res_file2,T{i}));
    %generates the performances file name for every time window
    perf=sprintf('%s_%s.dat',pe, T{i});
    if(exist(perf))
        delete(perf);
    end
    fprintf('\n\nCalling perf_loo_ti.m Ti=%s\n\n', T{i});
    perf_loo_ti(filein, kmeans, pre, re, acc, inform, mark, cm);
end
    
