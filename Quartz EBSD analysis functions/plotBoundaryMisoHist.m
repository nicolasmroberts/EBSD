function [] = plotBoundaryMisoHist(mergedGrainsSmall, phase)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%

if nargin < 2
        phase = 'Quartz-new';  
end

figure,
plotAngleDistribution(mergedGrainsSmall.boundary(phase,phase).misorientation,...
  'DisplayName',sprintf('Correlated %s (1° minimum)', phase))
    
legend('show','Location','northwest')
title('1° Boundary (correlated) Misorientations')

end

