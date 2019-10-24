function [Boundaries] = computeBoundaryMisoAxes(grainsSmall,phase)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

% define phase
if nargin < 2
        phase = 'Quartz-new';  
end


%% compute the grain boundaries
allGB = grainsSmall.boundary.reorder;

%% outer boundaries for a given phase
GBphase = allGB(phase,phase);

%% inner boundaries for a given phase
inerB = grainsSmall.innerBoundary(phase,phase);

%% Concatenate boundaries (inner and outer)
Boundaries = [GBphase;inerB];
end

