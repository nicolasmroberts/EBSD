%% Plot IPF Z orientation map 

plot(ebsd('Quartz-new'), ebsd('Quartz-new').orientations,'coordinates','on')

% nextAxis
% ipfKey = ipfColorKey(ebsd('Quartz-new'));
% plot(ipfKey)





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

ebsd = ebsd(ebsd.mad<1.2);




%% CALCULATE GRAINS

[grains, ebsd] = constructQuartzGrains(ebsd,10); %10 degree threshhold for grains





%% PLOT GRAINS

figure, 
plot(ebsd('Quartz-new'), ebsd('Quartz-new').orientations,'coordinates','on')
hold on
plot(grains.boundary,'linewidth',1, 'linecolor','yellow')
hold off







%% One Point Per Grain CPO

grains_limited = grains(grains.grainSize > 0)
grainsQuartz = grains_limited('Quartz-new');

onePointPerGrainQuartzPF(grainsQuartz)








%% Crystallogrpahic Vorticity Axes (after Michels et al., 2015)
    
[ebsdVortQuartz, ebsdBulkVortQuartz] = calcGrainsDispersion(grains('Quartz-new'), ebsd('Quartz-new'));


%% Plot CVA results

plotCVAResults(ebsdVortQuartz, ebsdBulkVortQuartz)








%% Misorientation Analysis

%% make small grains with 1° difference for correlated Misorientation Analysis
[grainsSmall, ebsdSmall] = constructQuartzGrains(ebsd,1); %1 degree threshhold for grains

%% Plot small grains

figure, 
plot(ebsdSmall('Quartz-new'), ebsdSmall('Quartz-new').orientations,'coordinates','on')
hold on
plot(grainsSmall.boundary,'linewidth',1, 'linecolor','yellow')
hold off


%% COMPUTE THE UNCORRELATED MISORIENTATIONS OF QUARTZ

[uncorrMis, odf, uncorrMDF, Mindex] = computeUncorrelatedMiso(ebsdSmall);


%% PLOT UNCORRELATED MISORIENTATION OF QUARTZ

plotUncorrelatedMisoHist(uncorrMis, odf, uncorrMDF, Mindex, 'Quartz')


%% Correlated Misorientation Analysis

% Optional: you can remove the 60° dauphine twins that produce a big
% spike in the correlation (aka boundary) misorientations. THIS TAKES A LONG TIME 
% [mergedGrainsSmall,grainsSmall] = removeDauphineTwins(grainsSmall, CS)
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





    
    
    
    
    
    
    
% %% restrict data to one single grain
% 
% id = 41760;
% oneGrain = grains(41760);
% ebsd = ebsd(oneGrain);
% 
% plot(ebsd,ebsd.orientations)
% 
% hold on
% plot(oneGrain.boundary,'micronbar','off')
% hold off
% 
% %% Change the color bar to see small orientation differences
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% Median Filter smoothing
% 
% F = medianFilter;
% 
% % define the size of the window to be used for finding the median
% F.numNeighbours = 3; % this corresponds to a 7x7 window
% 
% % smooth the data
% ebsd_smoothed = smooth(ebsd,F);
% 
% % plot the smoothed data
% plot(ebsd_smoothed('indexed'),...
%   ipfKey.orientation2color(ebsd_smoothed('indexed').orientations),'micronbar','off')
% 
% hold on
% plot(oneGrain.boundary,'linewidth',2)
% hold off
% 
% 
% %%
% 
% %% Calculate the CVA, after Michels et al. (2015)
%     
%     [ebsdVortQuartz, ebsdBulkVortQuartz] = calcGrainsDispersion(grains('Quartz-new'), ebsd('Quartz-new'));
% 
% %% Plot CVA results
% 
% figure,
% plot(ebsdVortQuartz.eV1, 'antipodal','lower','contourf','halfwidth',10*degree), mtexColorMap(flipud(lbmap(64,'RedBlue'))), mtexColorbar
% hold on
% % The next 2 lines add a colorbar and labels it
% c = mtexColorbar;
% c.Label.String = 'M.U.D.';
% % This next line adds a text box that says how many measurements are used
% % in theplot
% annotation('textbox',[0 .7 0 .3],'String',sprintf('Quartz',length(ebsdVortQuartz.CVA)),'FitBoxToText','on');
% 
% % Add the bulk/preferred CVA axis
% plot(ebsdBulkVortQuartz,'antipodal','lower','Marker','^','MarkerSize', 15,'MarkerEdgeColor','w','MarkerFaceColor','k')
% plot(-yvector,'plane','LineColor','k')
% plot(xvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','^','MarkerSize',12)
% plot(-yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','s','MarkerSize',12)
% plot(yvector,'MarkerEdgeColor','k','MarkerFaceColor','w','Marker','o','MarkerSize',12)
% drawnow
% mtexColorbar
% 
% 
% 
% 
% %%
% 
% 
% %% Misorientation analysis
% phase = 'Almandine'
% 
% figure,
%      plot(ebsd(phase),ebsd(phase).mis2mean.angle./degree)
%      mtexColorMap WhiteJet
%      mtexColorbar
%      hold on
%      plot(grains.boundary,'k''linewidth',.5)
%      hold off
% 
%      
% 
% %% CalcMiso
% 
% % make small grains with 1° difference
% [grainssmall,ebsdsmallG.grainId,ebsdsmallG.mis2mean] = calcGrains(ebsd,'angle',1*degree);
% 
% 
% %% %% compute **uncorrelated** misorientations
% uncorr = calcMisorientation(ebsd(phase),ebsd(phase));
% 
%  
% %% compute an ODF so can make lines to show "untextured"
% odf = calcODF(ebsd(phase).orientations,'Fourier');
% 
%  
% %% compute the uncorrelated misorientation distribution function
% uncorr_mdf = calcMDF(odf,odf);
% 
%  
% %% Make a plot
% figure
% plotAngleDistribution(corr)
% hold on
% plotAngleDistribution(uncorr)
% plotAngleDistribution(uncorr_mdf,'Color','m')
% plotAngleDistribution(odf.CS,odf.CS,'Color','k')
% mtexColorMap(map)
% legend('Correlated','Unorrelated','Uncorr MDF','untextured','Location','northwest')
% 
% titlestring=sprintf('Misorientation angles for %s (correlated across grain boundaries)', phase);
% title(titlestring);
% hold off
% %saveas(gcf,sprintf('%s %s gb_corr & uncorr angledist',samplename,phase))
% 
% 
% %% compute **correlated** misorientations
% corr = grainssmall.boundary(phase,phase).misorientation;
% 
% 
% 
% %% Make a plot
% figure,
% plotAngleDistribution(uncorr)
% hold on
% plotAngleDistribution(corr)
% 
% plotAngleDistribution(uncorr_mdf,'Color','m')
% plotAngleDistribution(odf.CS,odf.CS,'Color','k')
% mtexColorMap(map)
% legend('Correlated','Uncorrelated','Uncorr MDF','untextured','Location','northwest')
% titlestring=sprintf('Misorientation angles for %s, one degree', phase);
% title(titlestring);
% hold off
% % saveas(gcf,sprintf('%s %s uncorr & corr angledist',samplename,phase))
% 
% %last plot of just uncorrelated with untextured ODF and mdf
% figure,
% plotAngleDistribution(uncorr)
% hold on
% plotAngleDistribution(uncorr_mdf,'Color','m')
% hold on
% plotAngleDistribution(odf.CS,odf.CS,'Color','k')
% legend('Uncorrelated','Uncorr MDF','untextured','Location','northwest')
% titlestring=sprintf('Uncorrelated misorientation angles for %s', phase);
% title(titlestring);
% hold off
% %saveas(gcf,sprintf('%s %s uncorrelated angledist',samplename,phase))
% 
% %% 
% 
% %% axis distributions
% %% compute the grain boundaries
% gB = grainssmall.boundary.reorder;
% 
% %% outer boundaries for a given phase
% gB_phase = gB(phase,phase);
% 
% %% inner boundaries for a given phase
% inerB = grainssmall.innerBoundary(phase,phase);
% 
% %% Concatenate boundaries (inner and outer)
% all_B = [gB_phase;inerB];
% 
% %% compute the misorientations for the grain boundaries
% misor = all_B.misorientation;
% phase_ax = (misor.axis);
% phase_ang = misor.angle./degree;
% 
% %% compute **correlated** misorientations
% corr = misor;
% 
% 
% %% Separate correlted axes
% % mis_1_10 = misor(phase_ang<10 & phase_ang>=1);
% % mis_10_20 = misor(phase_ang<20 & phase_ang>=10);
% % mis_20_30 = misor(phase_ang<30 & phase_ang>=20);
% % mis_30_40 = misor(phase_ang<40 & phase_ang>=30);
% % mis_40_50 = misor(phase_ang<50 & phase_ang>=40);
% % mis_50_60 = misor(phase_ang<60 & phase_ang>=50);
% % mis_60_70 = misor(phase_ang<70 & phase_ang>=60);
% % mis_70_80 = misor(phase_ang<80 & phase_ang>=70);
% % mis_80_90 = misor(phase_ang<90 & phase_ang>=80);
% % mis_90_100 = misor(phase_ang<100 & phase_ang>=90);
% % mis_100_110 = misor(phase_ang<110 & phase_ang>=100);
% % mis_110_120 = misor(phase_ang<120 & phase_ang>=110);
% % mis_120_130 = misor(phase_ang<120 & phase_ang>=110);
% % mis_130_140 = misor(phase_ang<120 & phase_ang>=110);
% % mis_140_150 = misor(phase_ang<120 & phase_ang>=110);
% % mis_150_160 = misor(phase_ang<120 & phase_ang>=110);
% % mis_110_120 = misor(phase_ang<120 & phase_ang>=110);
% % mis_160_170 = misor(phase_ang<120 & phase_ang>=110);
% 
% 
% %% Loop to plot and save them
% angs = [1 10:10:10];
% samplename = "AME18_218"
% 
% for i = 1:length(angs)-1
%     misaxesfig = figure,
%     misaxesfig.PaperPositionMode = 'auto';
%     misplot = misor(phase_ang<angs(i+1) & phase_ang>=angs(i));
%     plotAxisDistribution(misplot,'smooth')
%     hold on
%     drawnow
%     mtexColorbar
%     set(gca,'YDir','reverse');
%     annotation('textbox',[.55 .6 0 .3],'String',sprintf('%s\n%i°-%i°\nn = %i ',phase,angs(i),angs(i+1),length(misplot)),'FitBoxToText','on');
%     saveas(gcf,sprintf('%s %s Misor axes %i-%i.png',samplename,phase,angs(i),angs(i+1)))
%     hold off
% end
% 
% 
% 
% %% THE FOLLOWING IS ONLY IF YOU PLAN TO ROTATE THE DATA SO THAT THE CVA AXIS IS IN THE CENTER
% 
% 
% 
% %% Plot the bulk vorticity axis alone
% plot(ebsdBulkVortQuartz,'antipodal','lower','Marker','^','MarkerSize', 15,'MarkerEdgeColor','w','MarkerFaceColor','k')
% 
% 
% 
% %% Figure out the rotation needed to bring the CVA bulk axis to the center of the plot
% bulkVort = ebsdBulkVortQuartz(1);
% 
% axisVec = cross(vector3d.Z, ebsdBulkVortQuartz(1));
% [trend, plunge, r] = cart2sph(bulkVort.x, bulkVort.y, bulkVort.z);
% 
% rotAngle = -(pi/2 + plunge);
% 
% rot = rotation('axis', axisVec, 'angle', -rotAngle);
%     
% figure,
% plot([bulkVort, axisVec, rotate(bulkVort,rot)],'antipodal','lower','Marker','^','MarkerSize', 15,'MarkerEdgeColor','w','MarkerFaceColor','k')
% 
% %% Rotate EBSD data and reconstruct grains
% 
% ebsd_rot = rotate(ebsd, rot);
% [grains_rot, ebsd_rot.grainId, ebsd_rot.mis2mean] = calcGrains(ebsd_rot);
% 
% %% Plot the ebsd orientations before and after rotation
% 
% % not rotated
% cs = ebsd('Quartz-new').CS
% h = [Miller(0,0,0,1, cs),Miller(1,1,-2,0, cs), Miller(1,0,-1,0, cs)];
% figure,
% plotPDF(ebsd('Quartz-new').orientations,h,'TR','antipodal')
% 
% % rotated
% cs = ebsd_rot('Quartz-new').CS
% h = [Miller(0,0,0,1, cs),Miller(1,1,-2,0, cs), Miller(1,0,-1,0, cs)];
% figure,
% plotPDF(ebsd_rot('Quartz-new').orientations,h,'TR','antipodal','contourf')
% %% Recalculate CVA to check you have done the rotation right 
% 
% [ebsdVortQuartz_rot, ebsdBulkVortQuartz_rot] = calcCVAphase(ebsd_rot, grains_rot,'Quartz-new');
% 
% 
% %% Plot rotated Quartz CPO
% 
% grains_rot_large = grains_rot(grains_rot.grainSize >0)
% 
% grainsQuartz = grains_rot('Quartz-new');
% 
% quartzCPO = calcODF(grainsQuartz.meanOrientation,'halfwidth', 10*degree);
% 
% h = [Miller(0,0,0,1, quartzCPO.CS),Miller(1,1,-2,0, quartzCPO.CS), Miller(1,0,-1,0, quartzCPO.CS)];
% k = [Miller(0,0,0,1, grainsQuartz.CS),Miller(1,1,-2,0, grainsQuartz.CS), Miller(1,0,-1,0, grainsQuartz.CS)];
% 
% figure,
%     plotPDF(quartzCPO, h, 'TR', 'lower', 'antipodal','contourf')
%     mtexColorMap white2black
%     CLim(gcm,'equal')
%     mtexColorbar
%     %plotPDF(grainsQuartz.meanOrientation, k,'all', 'lower','antipodal', 'MarkerFaceColor', 'k', 'MarkerSize', 1, 'MarkerShape', 'o')
% 
% %% Plot rotated Inverse Pole Figure
% 
% %% One point per grain Inverse Pole Figures 
% figure,
%     plotIPDF(quartzCPO, h, 'TR', 'lower', 'antipodal','contourf')
%     CLim(gcm,'equal')
%     mtexColorbar