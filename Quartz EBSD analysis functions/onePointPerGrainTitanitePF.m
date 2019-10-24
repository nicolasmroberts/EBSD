function [] = onePointPerGrainTitanitePF(grainsTitanite)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

titaniteCPO = calcODF(grainsTitanite.meanOrientation,'halfwidth', 10*degree);

h = [Miller(1,0,0, titaniteCPO.CS), Miller(0,1,0, titaniteCPO.CS), Miller(0,0,1, titaniteCPO.CS)]
% k = [Miller(0,0,0,1, grainsQuartz.CS),Miller(1,1,-2,0, grainsQuartz.CS), Miller(1,0,-1,0, grainsQuartz.CS)];

figure,

            nextAxis
            plotPDF(titaniteCPO, h, 'TR', 'lower', 'antipodal')
            mtexColorbar

end
