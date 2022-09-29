function [fMeanMag, fBValue, fStdDev, fAValue] =  calc_bmemag(mCatalog, fBinning);
% function [fMeanMag, fBValue, fStdDev, fAValue] =  calc_bmemag(mCatalog, fBinning)
% ---------------------------------------------------------------------------------
% Calculates the mean magnitute, the b-value based 
% on the maximum likelihood estimation, the a-value and the 
% standard deviation of the b-value
%
% Input parameters:
%   mCatalog        Earthquake catalog
%   fBinning        Binning of the earthquake magnitudes (default 0.1)
%
% Output parameters:
%   fMeanMag        Mean magnitude
%   fBValue         b-value
%   fStdDev         Standard deviation of b-value
%   fAValue         a-value
%
% Danijel Schorlemmer
% June 2, 2003

global bDebug;
if bDebug
  disp('This is calc_bmemag.m');
end  


% Set the default value if not passed to the function
if ~exist('fBinning')
  fBinning = 0.1;
end;

% Check input
[nY,nX] = size(mCatalog);

if (~isempty(mCatalog) & nX == 1) 
    vMag = mCatalog;
elseif (~isempty(mCatalog) & nX > 1)
    vMag = mCatalog(:,6);
else
    disp('No magnitude data available!');
    return
end;

% Calculate the minimum and mean magnitude, length of catalog
nLen = length(vMag);
fMinMag = min(vMag);
fMeanMag = mean(vMag);
% Calculate the b-value (maximum likelihood)
fBValue = (1/(fMeanMag-(fMinMag-(fBinning/2))))*log10(exp(1));   
% Calculate the standard deviation 
fStdDev = (sum((vMag-fMeanMag).^2))/(nLen*(nLen-1));
fStdDev = 2.30 * sqrt(fStdDev) * fBValue^2;            
% Calculate the a-value
fAValue = log10(nLen) + fBValue * fMinMag;

