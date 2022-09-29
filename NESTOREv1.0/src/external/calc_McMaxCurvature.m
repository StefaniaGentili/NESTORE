function [fMc] = calc_McMaxCurvature(mCatalog)
% function [fMc] = calc_McMaxCurvature(mCatalog);
% -----------------------------------------------
% Determines the magnitude of completeness at the point of maximum
%   curvature of the frequency magnitude distribution
%
% Input parameter:
%   mCatalog        Earthquake catalog
%
% Output parameter:
%   fMc             Magnitude of completeness, nan if not computable
%
% Danijel Schorlemmer
% November 7, 2001

global bDebug;
if bDebug
  disp('This is calc_McMaxCurvature.m');
end  

try 
  % Get maximum and minimum magnitudes of the catalog
  fMaxMagnitude = max(mCatalog(:,6));
  fMinMagnitude = min(mCatalog(:,6));
  if fMinMagnitude > 0
    fMinMagnitude = 0;
  end
  
  % Number of magnitudes units
  nNumberMagnitudes = (fMaxMagnitude*10) + 1;
  
  % Create a histogram over magnitudes
  vHist = zeros(1, nNumberMagnitudes);
  [vHist, vMagBins] = hist(mCatalog(:,6), (fMinMagnitude:0.1:fMaxMagnitude));
  
  % Get the points with highest number of events -> maximum curvature  
  fMc = vMagBins(max(find(vHist == max(vHist))));
  if isempty(fMc)
    fMc = nan;
  end 
catch
  fMc = nan;
end




