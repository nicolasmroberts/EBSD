%% Plot IPF Z orientation map 

plot(ebsd('Quartz-new'), ebsd('Quartz-new').orientations,'coordinates','on')

% nextAxis
% ipfKey = ipfColorKey(ebsd('Quartz-new'));
% plot(ipfKey)


%% just plot EBSD phase map
figure,
plot(ebsd)

%% SUBSET DATA? 

[GrainArea1, InverseOfArea1] = selectComplexPoly(ebsd);

ebsd = ebsd(GrainArea1);




%% PLOT QUARTZ POLE FIGURE

csQuartz = ebsd('Quartz-new').CS;

figure,
plotPDF(ebsd('Quartz-new').orientations, Miller(0,0,0,1,csQuartz),'lower', 'contourf')
text([vector3d.X,vector3d.Y,vector3d.Z],{'X','Y','Z'},'backgroundColor','w')
mtexColorbar






%% Plot ebsd map colored by Mean Angular Deviation (MAD)

figure,
hist(ebsd.mad)






%% Filter out all data with MAD > 1 and plot phase map

ebsd = ebsd(ebsd.mad < 1);




%% CALCULATE GRAINS
 [grains, ebsd] = constructGrains(ebsd,10); %10 degree threshhold for grains

% [grains, ebsd] = constructQuartzGrains(ebsd,10); %10 degree threshhold for grains





%% PLOT GRAINS and quartz orientation

figure, 
plot(ebsd('Quartz-new'), ebsd('Quartz-new').orientations,'coordinates','on')
hold on
% If you have multiple phases, you can add lines like the one below
% plot(ebsd('Anorthite'), ebsd('Anorthite').orientations, 'coordinates', 'on')
% plot(ebsd('Orthoclase'), ebsd('Orthoclase').orientations, 'coordinates', 'on')

plot(ebsd('Titanite'), ebsd('Titanite').orientations, 'coordinates', 'on')
plot(ebsd('Titanomagnetite'), ebsd('Titanomagnetite').orientations, 'coordinates', 'on')
plot(ebsd('Biotite'), ebsd('Biotite').orientations, 'coordinates', 'on')
% plot the grain boundaries
plot(grains.boundary,'linewidth',1, 'linecolor','black','linewidth',2)
hold off


%% PLOT JUST GRAINS

plot(grains)



%% One Point Per Grain CPO

grains_limited = grains(grains.grainSize > 0)


grainsQuartz = grains_limited('Quartz-new');
% grainsAnorthite = grains_limited('Anorthite')
grainsTitanite = grains_limited('Titanite')



onePointPerGrainQuartzPF(grainsQuartz)
onePointPerGrainTitanitePF(grainsTitanite)

% onePointPerGrainAnorthitePF(grainsAnorthite)



%% Crystallogrpahic Vorticity Axes (after Michels et al., 2015)
    
 [ebsdVortQuartz, ebsdBulkVortQuartz] = calcGrainsDispersion(grains('Quartz-new'), ebsd('Quartz-new'));

% [ebsdVortTitanite, ebsdBulkVortTitanite] = calcGrainsDispersion(grains('Titanite'), ebsd('Titanite'));

% % you can do this with any phase
% [ebsdVortAnorthite, ebsdBulkVortAnorthite] = calcGrainsDispersion(grains('Anorthite'), ebsd('Anorthite'));
% 
% % or you can do a CVA for all phases
 % [ebsdVortAll, ebsdBulkVortAll] = calcGrainsDispersion(grains, ebsd);



%% Plot CVA results

 plotCVAResults(ebsdVortQuartz, ebsdBulkVortQuartz)

% plotCVAResults(ebsdVortTitanite, ebsdBulkVortTitanite, 'Titanite')
% plotCVAResults(ebsdVortAnorthite, ebsdBulkVortAnorthite, 'Anorthite')
% plotCVAResults(ebsdVortAll, ebsdBulkVortAll, 'All Phases')

%% Misorientation Analysis

%% make small grains with 1° difference for correlated Misorientation Analysis
[grainsSmall, ebsdSmall] = constructGrains(ebsd,0.2); %1 degree threshhold for grains

%% Plot small grains

figure, 
plot(ebsdSmall('Titanite'), ebsdSmall('Titanite').orientations,'coordinates','on')
hold on
plot(grainsSmall.boundary,'linewidth',1, 'linecolor','yellow')
hold off


%% COMPUTE THE UNCORRELATED MISORIENTATIONS OF QUARTZ

[uncorrMis, odf, uncorrMDF, Mindex] = computeUncorrelatedMiso(ebsdSmall,'Titanite');


%% PLOT UNCORRELATED MISORIENTATION OF QUARTZ

plotUncorrelatedMisoHist(uncorrMis, odf, uncorrMDF, Mindex, 'Titanite')


%% Correlated Misorientation Analysis

% Optional: you can remove the 60° dauphine twins that produce a big
% spike in the correlation (aka boundary) misorientations. THIS TAKES A LONG TIME 
% [mergedGrainsSmall,grainsSmall] = removeDauphineTwins(grainsSmall, CS);
% 
% plotBoundaryMisoHist(mergedGrainsSmall)

 plotBoundaryMisoHist(grainsSmall)
    
%% Uncorrelated axis distribution
figure,
plotAxisDistribution(uncorrMis,'smooth', 'antipodal')
mtexTitle('uncorrelated axis distribution')
    
%% Untextured axis distribution
figure,
plotAxisDistribution(ebsd('Quartz-new').CS,ebsd('Quartz-new').CS,'antipodal')
mtexTitle('random texture')
mtexColorMap parula
setColorRange('equal')
mtexColorbar('multiples of random distribution')

    
%% Misorienation axis distribution Pole Figure

% computationally expensive (takes a long time)
[boundaries] = computeBoundaryMisoAxes(grainsSmall);

boundaryMisoAxes = boundaries.misorientation;

%% MISORIENTATION Axis plot (1-10°)

figure,
plotAxisDistribution(boundaryMisoAxes(boundaryMisoAxes.angle./degree < 10),'smooth')
mtexTitle('Boundary (correlated) axis distribution 1° - 10°')
mtexColorbar

%% 
figure,
plotAxisDistribution(boundaryMisoAxes(boundaryMisoAxes.angle./degree < 10),'smooth')
mtexTitle('Boundary (correlated) axis distribution 1 to 10 degree')
mtexColorbar

nextAxis
plotAxisDistribution(uncorrMis,'smooth', 'antipodal')
mtexTitle('uncorrelated axis distribution')

nextAxis
plotAxisDistribution(ebsd('Quartz-new').CS,ebsd('Quartz-new').CS,'antipodal')
mtexTitle('random texture')
mtexColorMap parula
setColorRange('equal')


%% Misorientation axis Pole Figure

plotMisoAxisPoleFigure(ebsdSmall, boundaries(boundaries.misorientation.angle./degree < 10))




%% Recrystallized Grainsize Analysis
    

sampleName = 'AME16_132XZ'; % Compatible with both .ctf and .cpr/crc formats


recrystallizedGrainSize(ebsd, grains,CS, sampleName)


%% GrainSize

plotGrainSizeECD(grains)


%% WHITEJET MIS TO MEAN MAP

phase = ('Quartz-new')

figure,
     plot(ebsd(phase),ebsd(phase).mis2mean.angle./degree)
     mtexColorMap WhiteJet
     mtexColorbar
     hold on
     plot(grains.boundary,'k''linewidth',.5)
     hold off
     

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
 %% INDIVIDUAL GRAINWORK
 
 % Plot the grains so that you can click on them and figure out their grain
 % ID number
 plot(grains('Titanite'))
 
 %% Save the grain number 
 grainNumber = 354; 
 
 %% isolate EBSD data to only that within the grain
 
 ebsdSG = ebsd(ebsd.grainId == grainNumber);
 
plot(ebsdSG('Titanite'), ebsdSG('Titanite').orientations)

%% Create 0.2° boundaries
[grainsSG, ebsdSG] = constructGrains(ebsdSG, .2)

 %% Look at the grain using a Mis2Mean white jet color scale
 
 phase = ('Titanite')

figure,
     plot(ebsdSG(phase),ebsdSG(phase).mis2mean.angle./degree)
     mtexColorMap WhiteJet
     mtexColorbar
     hold on
     plot(grainsSG.boundary,'k''linewidth',.5)
     hold off
 
 %% Misorientation Histograms
 
 %% COMPUTE THE UNCORRELATED MISORIENTATIONS OF QUARTZ

[uncorrMisSG, odfSG, uncorrMDFSG, MindexSG] = computeUncorrelatedMiso(ebsdSG,'Titanite');


%% PLOT UNCORRELATED MISORIENTATION OF QUARTZ

plotUncorrelatedMisoHist(uncorrMisSG, odfSG, uncorrMDFSG, MindexSG, 'Titanite')

%% Correlated Misorientation Analysis

 plotBoundaryMisoHist(grainsSG, 'Titanite')
    
%% Uncorrelated axis distribution
figure,
plotAxisDistribution(uncorrMisSG,'smooth', 'antipodal')
mtexTitle('uncorrelated axis distribution')
    
%% Misorienation axis distribution Pole Figure

% computationally expensive (takes a long time)
[boundariesSG] = computeBoundaryMisoAxes(grainsSG, 'Titanite');

boundaryMisoAxesSG = boundariesSG.misorientation;

%% MISORIENTATION Axis plot (1-10°)

figure,
plotAxisDistribution(boundaryMisoAxesSG(boundaryMisoAxesSG.angle./degree < 10),'smooth')
mtexTitle('Boundary (correlated) axis distribution 1° - 10°')
mtexColorbar

%% 
figure,
plotAxisDistribution(boundaryMisoAxesSG(boundaryMisoAxesSG.angle./degree < 10),'smooth')
mtexTitle('Boundary (correlated) axis distribution 1 to 10 degree')
mtexColorbar

nextAxis
plotAxisDistribution(uncorrMis,'smooth', 'antipodal')
mtexTitle('uncorrelated axis distribution')

nextAxis
plotAxisDistribution(ebsdSG('Titanite').CS,ebsdSG('Titanite').CS,'antipodal')
mtexTitle('random texture')
mtexColorMap parula
setColorRange('equal')


%% Misorientation axis Pole Figure

plotMisoAxisPoleFigure(ebsdSG, boundariesSG(boundariesSG.misorientation.angle./degree < 10))

 
 