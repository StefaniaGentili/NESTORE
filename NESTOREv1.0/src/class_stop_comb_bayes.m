function [pc]=class_stop_comb_bayes(pi,na,nb)
% Combines the probabilities of independent different classificators.
% by a Bayesian approach for NESTORE "A class" probability estimation
%
% REF= C. A. L. Bailer-Jones, K. Smith (2011) "Combining probabilities" 
% Max Planck Institute for Astronomy Heidelberg
% GAIA-C8-TN-MPIA-BBJ-053
%
% If the product of the probabilies AND the product of 1- probabilities are
% 0, supplies as final probability the median of probabilities
%
% INPUT:
% pi = vector of probabilities for single classificators
% na = number of elements of A class
% nb = number of elements of B class
%
% OUTPUT:
% pc = combined NESTORE A class probability 
%
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
% P. Brondi pbrondi@ogs.it
% License: GNUGPLv3
% last update: July 22, 2022

fprintf('\n\nThis is class_stop_comb_bayes.m \n\n');

n=length(pi);


p_prod=(nb^(n-1))*prod(pi);
np_prod=(na^(n-1))*prod(1-pi);

tot=p_prod+np_prod;

%calculates the probability by Bayesian approach if tot>0; otherwise sets
%pc to the median of the probabilities
if(tot>0)
    pc=p_prod/(tot);
else
    pc=median(pi);
end