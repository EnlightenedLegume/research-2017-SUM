function height = predictTide(time,coeffs);
% Predicts tides for given times and coefficients from Webcritech
% 
% INPUTS
% height = predictTide(time,coeffs)
%         Takes a double vector of times (<time>) in days and a Nx4
%         matrix of coefficients (<coeffs>), where col 1 is
%         harmonic number, col 2 is period (days), col 3 is the cos
%         coefficient and col 4 is the sin coefficient
% OUTPUTS 
% height  Height of the tide in meters. Double vector of the same
%         length as the input <time>
    
% Created by Benjamin Huang on 06/23/2017
    
% Force <time> to a column vector by unpacking
time  = time(:);
% Transpose <time> to a row vector (for vector multiplication)
time = time';
% Pull out the first constant (cosine coefficient, 0 harmonic)
height = coeffs(1,3);
% Write lambda function to calculate height contribution from each
% harmonic 
harmonics = @(cosCoeff,sinCoeff,per,t) cosCoeff.*cos(per*t) + ...
    sinCoeff.*sin(per*t);
% Breakup <coeffs> into constituents
cosCoeffs = coeffs(2:end,3);
sinCoeffs = coeffs(2:end,4);
% Convert to period
pers = 2*pi./coeffs(2:end,2);
% Input into previously defined lambda function
ih = harmonics(cosCoeffs,sinCoeffs,pers,time);
% Calculate height
height = height + sum(ih);
