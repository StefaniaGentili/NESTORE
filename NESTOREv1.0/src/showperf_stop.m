function showperf_stop(td,FEA, res_file, res_file2, COL, MK, MS)
% Reads the performance files (estimators)and shows them. 
% each performance file is evaluated in the  "good" interval that is 
% written in the range file

% Input:
% td        = time intervals (number [days])
% FEA       = considered features names
% res_file  = first part of the name of the feature file
% res_file2 = first part of the name of the feature file calculated in the 
%             good interval
% COL       = color of the lines
% MK        = symbols of the markers
% MS        = markers size

% Output: visualization of the results 

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
% last change July 7, 2022

fprintf('\n\nThis is showperf_stop\n\n');

%generates the names of the estimators
pre=fullfile('../data/Training_Output/',sprintf('pre_M2_stop_%s.dat', res_file2));
re=fullfile('../data/Training_Output/',sprintf('re_M2_stop_%s.dat', res_file2));
acc=fullfile('../data/Training_Output/',sprintf('acc_M2_stop_%s.dat', res_file2));
inform=fullfile('../data/Training_Output/',sprintf('inform_M2_stop_%s.dat', res_file2));
%generates the name of the range file
range_file=fullfile('../data/Training_Output/',sprintf('range_M2_%s.dat', res_file));
range=load(range_file);



v=[td(end)+1,td(end)+1];
[w,~]=size(range);
for(i=1:w-1)
    v=[v,range(i,1),range(i,2)];
end
v=[v,v(1),v(1),v(1),v(1)];
v=[v,range(w,1),range(w,2)];

for(i=1:length(v))
    b=find(td==v(i));
    if(isempty(b))
        u(i)=NaN;
    else
        u(i)=b;
    end
end

%shows the performances in terms of precision, recall, accuracy and
%Informedness of all features in the selected interval
showperf_stop_fig(pre,FEA, 'Precision',u, td, COL, MK, MS,1,res_file2);
showperf_stop_fig(re,FEA, 'Recall',u, td, COL, MK, MS,1,res_file2);
showperf_stop_fig(acc,FEA, 'Accuracy',u, td, COL, MK, MS,1,res_file2);
showperf_stop_fig(inform,FEA, 'Informedness',u, td, COL, MK, MS,1,res_file2);
