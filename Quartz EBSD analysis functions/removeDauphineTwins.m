function [mergedGrainsSmall,grainsSmall] = removeDauphineTwins(grainsSmall, CS)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
% Remove Dauphine twins
% Find all quartz-quartz grain boundaries
gb_qtz = grainsSmall.boundary('Quartz-new','Quartz-new');

% Find all boundaries with rotations of 60+/-5 degrees around the c-axis
% - these are Dauphine twins
rot = rotation('axis',Miller(0,0,0,1,CS{2}),'angle',60*degree);
ind = angle(gb_qtz.misorientation,rot)<5*degree; 
twinBoundary = gb_qtz(ind);

% Merge grains separated by twin boundaries 
% - this is computationally expensive
[mergedGrainsSmall,grainsSmall.prop.parentId] = merge(grainsSmall,twinBoundary);

end
