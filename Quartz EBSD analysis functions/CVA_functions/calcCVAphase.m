% This is a function for doing Crystallographic Vorticity Analysis on ebsd
% data. It outputs pole figures with bulk vorticity and vorticity axes by phase.
% STILL TO ADD: scripting for 'save as' with sample names and paths;
% rotations to bring CVA into geographic reference.

function [vorts,bulkVort] = calcCVAphase(ebsd, grains, phase)

% %% Clean data for MAD
% 
% % keep pixels with mad<1.0
% ebsdCorMad = ebsd(ebsd.mad<1.0);
% 
% %% Calculate grains and generate maps
% 
% [grains,ebsdCorMad.grainId,ebsdCorMad.mis2mean] = calcGrains(ebsdCorMad('indexed'),'angle',10*degree);
% 
% figure,
% plot(grains);
%% Select grains appropriate for CVA

% Makes a new variable 'g' that contains a subset of the grains (but still
% most of them) that are appropriate for CVA analysis (i.e., more than 3
% orientation solutions per grain, and *some* amount of intragranular
% misorientation).
grains = grains(phase);
g = grains(grains.grainSize>20&grains.phase>0&grains.GOS>0.01*degree);
numel(g)
e = ebsd(g);

%% Plot grains

figure('position',[0,0,4096,4096]);
plot(g,'property','phase');

drawnow;

%% calculate CVA axes

% vorts = CVA axes
% bulkVort = dominant CVA axis for grain set
% D = dispersion tensor as an orientation
% eV1 = 1st principal axis of dispersion tensor
% eV2 = 2nd principal axis of dispersion tensor
% eV3 = 3rd principal axis of dispersion tensor
% mags = magnitudes of CVA axes
% T = dispersion Tensor as a tensor (for each grain)

[vorts,bulkVort] = calcGrainsDispersion(g('indexed'),e);

%
% append the grainset, 'g' with the data from the CVA calcs
g.prop.cva = vorts';
g.prop.dispTensor = T;
g.prop.dispOr = D;
g.prop.Mag1 = mags(1,:)';
g.prop.Mag2 = mags(2,:)';
g.prop.Mag3 = mags(3,:)';
g.prop.E1 = eV1';
g.prop.E2 = eV2';
g.prop.E3 = eV3';



%% Plot mean CVA axis for all phases

figure,
plot(eV1, 'antipodal','lower','contourf','halfwidth',10*degree), mtexColorMap(flipud(lbmap(64,'RedBlue'))), mtexColorbar
hold on
% The next 2 lines add a colorbar and labels it
c = mtexColorbar;
c.Label.String = 'M.U.D.';
% This next line adds a text box that says how many measurements are used
% in theplot
annotation('textbox',[0 .7 0 .3],'String',sprintf(char(phase),length(g.cva)),'FitBoxToText','on');

% Add the bulk/preferred CVA axis
plot(bulkVort,'antipodal','lower','Marker','^','MarkerSize', 15,'MarkerEdgeColor','w','MarkerFaceColor','k')
plot(-yvector,'plane','LineColor','k')
plot(xvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','^','MarkerSize',12)
plot(-yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','s','MarkerSize',12)
plot(yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','o','MarkerSize',12)
drawnow
mtexColorbar

%% ZM Changed 6/17/2017: add code to do a *specific* geographic rotation for example:
%[trdAll,plgAll]=vec_2_tp_Vasilis_X2East(bulkVort)

