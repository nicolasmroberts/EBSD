function [] = plotCVAResults(ebsdVortQuartz, ebsdBulkVortQuartz, phaseLabel)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    phaseLabel = 'Quartz-new';
end


figure,
plot(ebsdVortQuartz.eV1, 'antipodal','lower','contourf','halfwidth',10*degree) 
mtexColorMap('white2black')

hold on
c = mtexColorbar;
c.Label.String = 'M.U.D.';
% This next line adds a text box that says how many measurements are used
% in theplot
annotation('textbox',[0 .7 0 .3],'String',sprintf(phaseLabel,length(ebsdVortQuartz.CVA)),'FitBoxToText','on');

% Add the bulk/preferred CVA axis
plot(ebsdBulkVortQuartz,'antipodal','lower','Marker','^','MarkerSize', 15,'MarkerEdgeColor','w','MarkerFaceColor','k')
plot(-yvector,'plane','LineColor','k')
plot(xvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','^','MarkerSize',12)
plot(-yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','s','MarkerSize',12)
plot(yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','o','MarkerSize',12)
drawnow

end

