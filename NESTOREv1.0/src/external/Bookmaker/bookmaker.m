% results = bookmaker([contingency matrix])
% 
% contingency matrix  ->  contingency table of network prediction and training targets
%                             ie. classification x target'
%                                         
% results             <-  structure of results with the following fields
%                             contingencyMatrix:  As provided as argument 1 to function
%                             recall:             Ratio of times class correctly predicted
%                                                 to total times it was actually that class
%                             precision:          Ratio of times class correctly predicted 
%                                                 to total times it was predicted to be that class
%                             weightedAverage:    Ratio of correct predicted classes
%                                                 to total number of cases
%                             F:                  Harmonic mean
%                             Fall:               F for all classes
%                             G:                  Geometric mean
%                             Gall:               G for all classes
%                             bookmakerMatrix:    Matrix of bookmaker results per class
%                             bookmaker:          Bookmaker result for all
%                                                 classes 
%                             markedness:         Markedness 
%                             
%
% matlab: sf 16/03/03
% octave: dp 11/04/03 - also extended to weight k>2 combinations of bm, F and G correctly
% octave: dp 30/12/07 - simplified and extended to markedness, correlation and detmination

% NOTES by s. Gentili and P. Brondi: 
% results.recall contains: [recall, inverse recall]
% results.precision contains: [precision, inverse precision]  
% results.bookmaker  is the Informedness, an unbiased variant of recall
% results.markedness is an unbiased variant of precision 



function [results,vectors] = bookmaker(cm)

if (size(cm,1) ~= size(cm,2))
    error('Contingency matrix must be square'); 
else
    k = size(cm,1);
end

N = sum(sum(cm));
rprob = sum(cm) ./ N;
pprob = sum(cm') ./ N;

recall = diag(cm)' ./ sum(cm);
precision = diag(cm')' ./ sum(cm');
wav = sum(diag(cm)) ./ N;

F = (2.*precision.*recall) ./ (precision + recall);
G = sqrt(precision.*recall);

% Fall - use weighted harmonic mean 
% Fall = k / sum(ones(1,k)./F); %(assume equiprobable)
Fall = 1 / sum(rprob./F); %(assume real distribution)

% Gall - use weighted geometric mean
% Gall = (prod(G)^(1/k)); %(assume equiprobable)
Gall = prod(G.^rprob); %(assume real distribution)

% mask = diag(ones(1,k)); % eye(k) for compatability
% maskc = reshape(mask,k*k,1);
% ind = find(maskc==0);
% maskc(ind) = -1;
% mask = reshape(maskc,k,k);

prob = rprob(ones(k,1),:)' - (ones(k,k) - eye(k));

bmcm = cm ./ prob;    
bms = sum(bmcm') / N;
bm = bms * pprob';

% modified for compatibility; previous version: clear bmcm, prob;
clear bmcm;
clear prob;


prob = pprob(ones(k,1),:)' - (ones(k,k) - eye(k));

mkcm = cm' ./ prob;    
mks = sum(mkcm') / N;
mk = mks * rprob';

% modified for compatibility; previous version: clear mkcn, prob;
clear mkcn;
clear prob;

%ipprob = ones(1,k) - pprob;
%irprob = ones(1,k) - rprob;
%ppprob = prod(pprob);
%prprob = prod(rprob);

dof = (k-1)*(k-1);
pow = 1-1/((k-1)*k);
eav = rprob*pprob';
excm = pprob'*rprob;
ll = sum(sum(cm.*log((cm+ones(k,k)*0.00001)/N./excm)));
g2 = 2*ll;
pg = 1-chi2cdf(g2,dof); % approx probabilty of this contingency or better
%chi2 = sum(sum((abs(cm-excm*N)).^2./(excm*N))); % uncorrected
%chi2 = sum(sum((abs(cm-excm*N)-0.5).^2./(excm*N))); % Yates correction
chi2 = sum(sum((abs(cm-excm*N)-pow).^2./(excm*N))); % Powers correction
px = 1-chi2cdf(chi2,dof); % approx probabilty of this contingency or better

% Fisher exact test - point probability [prod(realmar!)prod(predmar!)]/[N!prod(cell!)]
% gammaln(N+1) = ln(N!)
logmarfact = sum(gammaln(N.*[pprob,rprob]+ones(1,2*k)));
logcellNfact = sum(sum(gammaln(cm+ones(k,k))))+gammaln(N+1);
pf1 = exp(logmarfact-logcellNfact); % Fisher hypergeometric probability of this contingency
% Powers correction to Fisher exact test approximates the cdf from slope of pdf
pwr = log(N)/N; % or gammaln(N)/N^2
logpwrfact = sum(gammaln(N.*[pprob,rprob]+(1+pwr).*ones(1,2*k)));
pfp = exp(logpwrfact-logcellNfact); % approx probabilty of this contingency or better
if (pfp>0.5)
    pfp=pf1;
end

%results.contingencyMatrix = cm;
results.K = k; %1,48
results.N = N; 
results.degreesoffreedom = dof;
results.evenar = sum(rprob)/k; %4,51
results.evengr = prod(rprob)^(1/k);
results.evenhr = k/sum(1./rprob);
results.evenap = sum(pprob)/k;
results.evengp = prod(pprob)^(1/k);
results.evenhp = k/sum(1./pprob);
results.rratio = results.evenhr*results.evenar/results.evengr^2; %10,57
results.pratio = results.evenhp*results.evenap/results.evengp^2;
results.gratio = sqrt(results.pratio*results.rratio);
results.williamsr = 1+((k/results.evenhr-1))/(6*N*dof);
results.williamsp = 1+((k/results.evenhp-1))/(6*N*dof);
results.williamsg = 1+((k/results.evenhp-1)*(k/results.evenhr-1))^0.5/(6*N*dof);
results.detroot = abs(det(cm))^(1/k)/N; %16,63
results.randAverage = wav;
results.Fall = Fall;
results.Gall = Gall;
results.kappa = (wav - eav)/(1 - eav); %20,67
results.bookmaker = bm; %21,- can be negative
results.markedness = mk; %22,- can be negative
results.correlation = sqrt(abs(mk*bm)); %23,68 bm and mk can have opposite sign
results.dicorrelation = (results.detroot/results.evengr)^2; %24,69
results.dmcorrelation = (results.detroot/results.evengp)^2;
results.cramervgcorr = sqrt(g2/N/(k-1));
results.cramervxcorr = sqrt(chi2/N/(k-1));
results.determination = (mk*bm); %28,73
results.kdetermination = results.kappa^2;
results.bdetermination = bm^2;
results.mdetermination = mk^2;
results.cdeterminationa = (results.detroot^2/results.evenap/results.evenar)^2;
results.cdeterminationg = (results.detroot^2/results.evengp/results.evengr)^2;
results.cdeterminationh = (results.detroot^2/results.evenhp/results.evenhr)^2;
results.cramervgsqdet = results.cramervgcorr^2;
results.cramervxsqdet = results.cramervxcorr^2;
if(results.determination==0)
	results.detratioa = 0; %37,82
	results.detratiog = 0;
	results.detratioh = 0;
else
	results.detratioa = results.cdeterminationa/results.determination; %37,82
	results.detratiog = results.cdeterminationg/results.determination;
	results.detratioh = results.cdeterminationh/results.determination;
end
results.loglikelihood = ll; %40,85
results.gsq = g2;
results.mutualinformation = ll/N;
results.pearsonxsq = chi2;
results.pg = pg; %44,89
results.px = px;
results.fisherpf1 = pf1;
results.fisherpfp = pfp; %47,92

vectors.recall = recall;
vectors.precision = precision;
vectors.F = F;
vectors.G = G;
vectors.bookmakerSum = bms;
vectors.prevalence = rprob;
vectors.mardednessSum = mks;
vectors.bias = pprob;