function sh =  tidePredictionWebcritech(coeffs,t)

sh = coeffs(1,3);
sphHar = @(cosCoeff,sinCoeff,per,t) cosCoeff.*cos(per*t) + ...
         sinCoeff.*sin(per*t);
cosCoeffs = coeffs(2:end,3);
sinCoeffs = coeffs(2:end,4);
pers = 2*pi./coeffs(2:end,2);
ih = sphHar(cosCoeffs,sinCoeffs,pers,t);
sh = sh + sum(ih);

