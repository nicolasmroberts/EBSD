function [] = plotUncorrelatedMisoHist(uncorrMis, odf, uncorrMDF, Mindex, phaseLabel)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 5
        phaseLabel = 'Quartz-new';
   
end

%
figure,
plotAngleDistribution(uncorrMis,'DisplayName',phaseLabel)
hold on
plotAngleDistribution(uncorrMDF, 'DisplayName',phaseLabel)
plotAngleDistribution(odf.CS,odf.CS,'DisplayName','untextured')
hold off
legend('show','Location','northwest')
txt = {'M-index:',sprintf('%f',Mindex)};
t = text(5,7,txt);
t.FontSize = 14;
title('Uncorrelated Misorientations')
end

