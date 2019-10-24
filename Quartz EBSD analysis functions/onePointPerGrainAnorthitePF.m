function [] = onePointPerGrainAnorthitePF(grainsAnorthite)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

anorthiteCPO = calcODF(grainsAnorthite.meanOrientation,'halfwidth', 10*degree);

h = [Miller(0,1,0, anorthiteCPO.CS), Miller(0,0,1, anorthiteCPO.CS)]
% k = [Miller(0,0,0,1, grainsQuartz.CS),Miller(1,1,-2,0, grainsQuartz.CS), Miller(1,0,-1,0, grainsQuartz.CS)];

figure,
            plotPDF(anorthiteCPO, Miller(1,0,0, anorthiteCPO.CS, 'uvw'), 'TR', 'upper')
            mtexColorbar
            
            nextAxis
            plotPDF(anorthiteCPO, Miller(1,0,0, anorthiteCPO.CS, 'uvw'), 'TR', 'lower')
            
            nextAxis
            plotPDF(anorthiteCPO, h, 'TR', 'lower', 'antipodal')

end
