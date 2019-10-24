function [grains, ebsd] = constructGrains(ebsd, thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rawebsd = ebsd;
ebsd = ebsd('indexed');

% Construct grains using a critical misorientation of 10 degrees
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd,'angle',thresh*degree, 'boundary','tight');

% Remove wild spikes (1 pixel grains)
% - this step drastically reduces computation time, mostly w.r.t. twin merging
ebsd(grains(grains.grainSize == 1)).phase = 0;
ebsd = ebsd('indexed');

% Reconstruct grains without wild-spikes
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd,'angle',thresh*degree,'boundary','tight');

grains = smooth(grains,5);

end