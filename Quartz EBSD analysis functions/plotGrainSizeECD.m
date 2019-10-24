function [] = plotGrainSizeECD(grains)
%UNTITLED18 Summary of this function goes here
%   Detailed explanation goes here

% Separate grains that intersect the map boundary
face_id = grains.boundary.hasPhaseId(0);
bordergrain_id = grains.boundary(face_id).grainId;
bordergrain_id(bordergrain_id==0) = []; % Remove zeros

bordergrains = grains(ismember(grains.id,bordergrain_id));
nonbordergrains = grains(~ismember(grains.id,bordergrain_id));


%% Get area-equivalent circle diameters for all grains

d = 2*equivalentRadius(nonbordergrains);

%% Get grain size statistics for the recrystallized grains

amean_low = mean(d); % Arithmetic mean
gmean_low = 10^(mean(log10(d))); % Geometric mean
rmsmean_low = rms(d); % Root mean square (RMS)
median_low = median(d); % Median
mode_low = mode(d); % Mode
a1std_low = std(d); % 1 standard deviation


%% Plot grain size histograms

edges = [0:0.075:2.5]; % Set the histogram bin widths
loglim = [0 3.0 0 0.1]; % Set the histogram axis limits

figure,
histogram(log10(d),edges,'Normalization','probability',...
    'facecolor',[0.5 0.5 0.5]);
    axis(loglim)
     xlabel('Grain size (\mum)')
    ylabel('Relative frequency (%)')
    axis(loglim)
    set(gca,'xtick',[0:2])
    set(gca,'xticklabel',10.^get(gca,'xtick'),'yticklabel',100.*get(gca,'ytick'))
    
end

