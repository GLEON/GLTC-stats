function [vals] = getValsFromFit(time,fitParams,pivotPt)

if eq(nargin,2)
    dif = 0;
else
    xPt = pivotPt(1);
    yPt = pivotPt(2);

    dif = yPt-(xPt^2*fitParams.a+xPt*fitParams.b+fitParams.c);
end

v2 = time.^2;
vals = v2*fitParams.a+time.*fitParams.b+fitParams.c+dif;

vals = reshape(vals,length(vals),1);
end

