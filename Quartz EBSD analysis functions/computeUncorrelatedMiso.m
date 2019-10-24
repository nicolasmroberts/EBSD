function [uncorrMis, odf, uncorrMDF, Mindex] = computeUncorrelatedMiso(ebsdSmall,phase)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
        phase = 'Quartz-new';
   
end
    

% compute **uncorrelated** misorientations
uncorrMis = calcMisorientation(ebsdSmall(phase),ebsdSmall(phase));

% compute an ODF so can make lines to show "untextured"
odf = calcODF(ebsdSmall(phase).orientations,'Fourier');

% compute the uncorrelated misorientation distribution function
uncorrMDF = calcMDF(odf,odf);

% Calculate J- and M- index
Mindex = calcMIndex(odf); % skemer et al., 2015

end

