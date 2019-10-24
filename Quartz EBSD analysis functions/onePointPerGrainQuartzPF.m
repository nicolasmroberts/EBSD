function [] = onePointPerGrainQuartzPF(grainsQuartz)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

quartzCPO = calcODF(grainsQuartz.meanOrientation,'halfwidth', 10*degree);

h = [Miller(0,0,0,1, quartzCPO.CS),Miller(1,1,-2,0, quartzCPO.CS), Miller(1,0,-1,0, quartzCPO.CS)];
k = [Miller(0,0,0,1, grainsQuartz.CS),Miller(1,1,-2,0, grainsQuartz.CS), Miller(1,0,-1,0, grainsQuartz.CS)];

figure,
    plotPDF(quartzCPO, h, 'TR', 'lower', 'antipodal', 'contourf')
    CLim(gcm,'equal')
    mtexColorbar
end

