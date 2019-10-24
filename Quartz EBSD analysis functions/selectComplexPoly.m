
function [condition1, condition2] = selectComplexPoly(ebsd)
figure,
%plot(ebsd('Quartz-new'), ebsd('Quartz-new').orientations,'coordinates','on')
plot(ebsd)

active = input('Collect multi-polygon sub-sample? (lowercase y or n)     ', 's');

poly = selectPolygon;
region1 = poly;
condition1 = inpolygon(ebsd, region1);

while active == 'y'
    active = input('Keep adding to your sub-sample? (lowercase y or n)     ', 's');
    if active == 'y'
        polyTemp = selectPolygon(ebsd);
        regionTemp = polyTemp;
        conditionTemp = inpolygon(ebsd, regionTemp);
        condition1 = condition1 + conditionTemp;
    end
    

end

%make sure there are no numbers in condition1 > 1, in the case that the
%polygons overlapped
for i = 1:length(condition1)
    if condition1(i) > 0
        condition1(i) = 1;
    end
end
    
condition2 = ones(length(condition1),1) - condition1;

condition1 = logical(condition1);
condition2 = logical(condition2);

%plot(ebsd)
%region = [5 2 6 5]*10^3;
region1 = poly;

end 