function [fMc, fStd_Mc, fBvalue, fStd_B, fAvalue, fStd_A, vMc, mBvalue] = calc_McBboot(mCatalog, fBinning, nSample,  nMethod, nMinNum, fMcCorr)
% [fMc, fStd_Mc, fBvalue, fStd_B, fAvalue, fStd_A, vMc, mBvalue] = calc_McBboot(mCatalog, fBinning, nSample, nMethod, nMinNum, fMcCorr)
%--------------------------------------------------------------------------------------------------------------------------------------
% Calculate Mc, b-value and their uncertainties from bootstrapping
% Mc and b are actually the mean values of the empirical distribution
%
% Input parameters
% mCatalog    : Earthquake catalog
% fBinning    : Binning interval
% nSample     : Number of bootstraps to determine Mc
% nMethod     : Method to determine Mc (see calc_Mc)
% nMinNum     : Minimum number of events above Mc to calculate
% fMcCorr     : Correction term for Mc
%
% Output parameters
% fMc     : Mean Mc of the bootstrap
% fStd_Mc : 2nd moment of Mc distribution
% fBvalue : Mean b-value of the bootstrap
% fStd_B  : 2nd moment of b-value distribution
% fAvalue : Mean a-value of the bootstrap
% fStd_A  : 2nd moment of a-value distribution
% vMc     : Vector of Mc-values
% mBvalue : Matrix of [fMeanMag fBvalue fStdDev fAvalue]
%
% J. Woessner
% last update: 27.12.05

% Check input variables
% Minimum number of events
if ~exist('nMinNum', 'var')
    nMinNum = 50;
end

% Correction
if ~exist('fMcCorr', 'var')
    fMcCorr = 0;
end

% Initialize
vMc = [];
mBvalue = [];

% Check size of catalog
[nRow,nCol] = size(mCatalog);

% Restrict to minimum number
if nRow >= nMinNum
    % Get magnitudes
    vMags = mCatalog(:,6);
    % Reset randomizer
    rand('state',sum(100*clock));
    % Create bootstrap samples using bootstrap matlab toolbox
    mMag_bstsamp = bootrsp(vMags,nSample);
    % Determine Mc uncertainty
    for nSamp=1:nSample
        mCatalog(:,6) = mMag_bstsamp(:,nSamp);
        [fMc] = calc_Mc(mCatalog, nMethod, fBinning, fMcCorr);
        vMc =  [vMc; fMc];
        % Select magnitude range and calculate b-value
        vSel = mCatalog(:,6) >= fMc-fBinning/2;
        mCat = mCatalog(vSel,:);
        % Check static for length of catalog
        [nY, nX] = size(mCat);
        if nY >= nMinNum
            [fMeanMag, fBvalue, fStdDev, fAvalue] =  calc_bmemag(mCat, fBinning);
        else
            fMeanMag = nan;
            fBvalue = nan;
            fStdDev = nan;
            fAvalue = nan;
        end
        mBvalue = [mBvalue; fMeanMag fBvalue fStdDev fAvalue];

    end

    % Calculate mean Mc and standard deviation
    vSel = isnan(vMc);
    vMc = vMc(~vSel,:);
    fStd_Mc = calc_StdDev(vMc);
    fMc = nanmean(vMc);

    % Calculate mean b-value and standard deviation
    fStd_B = calc_StdDev(mBvalue(:,2));
    fStd_A = calc_StdDev(mBvalue(:,4));
    fBvalue = nanmean(mBvalue(:,2));
    fAvalue = nanmean(mBvalue(:,4));

else
    sString = ['Less than N = ' num2str(nMinNum) ' events'];
    disp(sString)
    % Set all values to nan
    fMeanMag = nan;
    fBvalue = nan;
    fStdDev = nan;
    fAvalue = nan;
    fMc = nan;
    fStd_Mc = nan;
    fStd_B = nan;
    fStd_A = nan;
end

