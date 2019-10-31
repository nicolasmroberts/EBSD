function [allOmega,a,b] = computeSPO(grains)

[omega, a, b] = fitEllipse(grains(aspectRatio(grains) > 1.2));

omega2 = mod(omega + pi, 2*pi);

allOmega = [omega; omega2];

end



