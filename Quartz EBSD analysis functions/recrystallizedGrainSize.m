function [grainSize,OneStanDev] = recrystallizedGrainSize(ebsd, grains,CS, sampleName)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
%% Remove twin boundaries

% Find all quartz-quartz grain boundaries
gb_qtz = grains.boundary('Quartz-new','Quartz-new');

% Find all boundaries with rotations of 60+/-5 degrees around the c-axis
% - these are Dauphine twins
rot = rotation('axis',Miller(0,0,0,1,CS{2}),'angle',60*degree);
ind = angle(gb_qtz.misorientation,rot)<5*degree; 
twinBoundary = gb_qtz(ind);

% Merge grains separated by twin boundaries 
% - this is computationally expensive
[mergedGrains,grains.prop.parentId] = merge(grains,twinBoundary);


%% Plot EBSD pixel data

% figure
% plot(ebsd,ebsd.orientations)
%     hold on
% plot(mergedGrains.boundary)

%% Remove poorly constrained grains

stepsize = ebsd(2).x - ebsd(1).x; % EBSD step-size (i.e. resolution) in microns

% Calculate the fraction of each grain's area that is made up of indexed
% pixels (0-1)
% - for example, fraction = 0.1 means that only 10% of that grain is made 
% up of indexed pixels (in other words, it's not very well constrained)
fraction = (full(mergedGrains.grainSize).*(stepsize^2))./mergedGrains.area; 

% Use trade-off curve to find cutoff between well-constrained and 
% poorly-constrained grains
% knee = tradeOff(fraction);
%     xlabel('Number of grains (cumulative)')
%     ylabel('Indexed fraction')

knee = 0.5;

% Keep only the well-constrained grains, and those made up of 4 or more pixels
condition = (full(mergedGrains.grainSize) >= 4) & (fraction > knee);
mergedGrains = mergedGrains(condition);


%% GOS thresholding

% If a relict grain is made up of multiple twins, those twins might not all
% be equally strained - some will have high GOS values, and some will have
% low GOS values. When identifying relict grains (those with high
% intragranular lattice distortion), we include grains that have at least
% one highly distorted twin. Thus, we need to find the GOS value of each
% individual twin

% Find individual twins belonging to merged grains
grains = grains(ismember(grains.parentId,mergedGrains.id));
    grains = grains(grains.grainSize >= 4);

% Use a trade-off curve to find the cutoff between low and high GOS values
knee = tradeOff(grains.GOS/degree);
        xlabel('Number of grains (cumulative)')
        ylabel('Grain Orientation Spread ( ^\circ )')


%% Separate out relict grains

% Find IDs of merged grains with high GOS values (> cutoff)
ids = unique(grains(grains.GOS/degree > knee).parentId);

relictGrains = mergedGrains(ismember(mergedGrains.id,ids));

% All other grains are those with low GOS values (i.e. recrystallized grains)
rexGrains = mergedGrains(~ismember(mergedGrains.id,ids));


%% Plot mis2mean (hot colours represent high internal misorientation)

figure
plot(ebsd,ebsd.mis2mean.angle/degree)
    hold on
plot(relictGrains.boundary) % Plot relict grain boundaries
    colorbar
    
        
%% Plot relict and recrystallized grains

figure
plot(relictGrains,'facecolor',[1 0.5 0.5]) % Relict grains = red
    hold on
plot(rexGrains,'facecolor',[0.5 0.5 1]) % Recrystallized grains = blue
    hold on
plot(mergedGrains.boundary) % Plot grain boundaries
        
        
%% Find merged grains that are bisected by the map border
% - we want to remove these for the grain size analysis

face_id = mergedGrains.boundary.hasPhaseId(0);
bordergrain_id = mergedGrains.boundary(face_id).grainId;
bordergrain_id(bordergrain_id==0) = []; % Remove zeros

bordergrains = mergedGrains(ismember(mergedGrains.id,bordergrain_id));
nonbordergrains = mergedGrains(~ismember(mergedGrains.id,bordergrain_id));


%% Get area-equivalent circle diameters for all grains

d = 2*equivalentRadius(nonbordergrains);


%% Get area-equivalent circle diameters for relict and recrystallized grains

% Find relict and recrystallized grains that aren't bisected by the map border
relictNonBorder = relictGrains(ismember(relictGrains.id,nonbordergrains.id));
rexNonBorder = rexGrains(ismember(rexGrains.id,nonbordergrains.id));

% Area equivalent circle diameters for relict and recrystallized grains
relictD = 2*equivalentRadius(relictNonBorder);
rexD = 2*equivalentRadius(rexNonBorder);


%% Get grain size statistics for the recrystallized grains

amean_low = mean(rexD); % Arithmetic mean
gmean_low = 10^(mean(log10(rexD))); % Geometric mean
rmsmean_low = rms(rexD); % Root mean square (RMS)
median_low = median(rexD); % Median
mode_low = mode(rexD); % Mode

a1std_low = std(rexD); % 1 standard deviation


%% Plot grain size histograms

edges = [0:0.075:2.5]; % Set the histogram bin widths
loglim = [0 2.5 0 0.25]; % Set the histogram axis limits
    
figure
set(gcf,'units','normalized','position',[0.15 0.15 0.7 0.5])


% Plot grain size distribution for all grains
subplot(1,2,1),
histogram(log10(d),edges,'Normalization','probability',...
    'facecolor',[0.5 0.5 0.5]);
    axis(loglim)
     xlabel('Grain size (\mum)')
    ylabel('Relative frequency (%)')
    axis(loglim)
    set(gca,'xtick',[0:2])
    set(gca,'xticklabel',10.^get(gca,'xtick'),'yticklabel',100.*get(gca,'ytick'))
    
    
% Plot separate grain size distributions for relict and recrystallized grains
subplot(1,2,2),
histogram(log10(relictD),edges,'Normalization','probability',...
    'facecolor',[1 0.2 0.2]); % Relict grain size histogram (red)
    hold on
histogram(log10(rexD),edges,'Normalization','probability',...
    'facecolor',[0.2 0.2 1]); % Recrystallized grain size histogram (blue)
    xlabel('Grain size (\mum)')
    ylabel('Relative frequency (%)')
    axis(loglim)
    set(gca,'xtick',[0:2])
    set(gca,'xticklabel',10.^get(gca,'xtick'),'yticklabel',100.*get(gca,'ytick'))
    

%% Display RMS recrystallized grain size

disp(' ')
disp(['RMS recrystallized grain size = ',num2str(rmsmean_low,3),...
    ' +/- ',num2str(a1std_low,3),' microns'])
disp(' ')

%%

grainSize = rmsmean_low

OneStanDev = a1std_low
end

