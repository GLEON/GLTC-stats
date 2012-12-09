function zBest = getBestDepth(dates,z)

% returns the "best" depth to use for lake. Will return the most sampled
% depth that is also the shallowest as a tiebreaker

% sort just in case
[z,srtI] = sort(z);
dates = dates(srtI);
unZ = unique(z);
yrCnt = zeros(1,length(unZ));
for i = 1:length(unZ)
    useI = eq(z,unZ(i));
    datesTemp = dates(useI);
    yr = datevec(datesTemp);
    yrCnt(i) = sum(unique(yr(:,1)));
end

[~,mxI] = max(yrCnt);
zBest = unZ(mxI);
end

