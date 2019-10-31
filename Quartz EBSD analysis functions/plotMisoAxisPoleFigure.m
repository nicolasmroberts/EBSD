function [] = plotMisoAxisPoleFigure(ebsdSmall, grainBoundaries, phaseLabel)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here

% Phase is only used for labeling the plot
if nargin < 3
        phaseLable = 'Quartz-new';
   
end
%% Get in specimen reference frame
% the following command gives a Nx2 matrix of orientations which contains
% for each boundary segment the orientation on both sides of the boundary.
ebsdI = ebsdSmall;
ori = ebsdI(grainBoundaries.ebsdId).orientations;

% the misorientation axis in specimen coordinates
phase_misor_axes = axis(ori(:,1),ori(:,2));
phase_misor_ang = angle(ori(:,1),ori(:,2),'antipodal')./degree;

figure,
plot(phase_misor_axes,'antipodal','lower','contourf','halfwidth',10*degree)
annotation('textbox',[0 .7 0 .3],'String',sprintf('All %s misorientation axes',phaseLable),'FitBoxToText','on');
mtexColorMap('white2black')
mtexColorbar



end

