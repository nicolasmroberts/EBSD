function [] = plotSPORose(allOmega,binAng)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%% plot roase diagram for all phases
figure
    polarhistogram(allOmega,360/binAng);
end

