function [location,coeffs] =  parsePred(stationId)
% Function to parse location and harmonic coefficients from the
% Webcritech website
% http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/TideGaugeDetails
% /stationId. Depends on parseCoeffs and
% parseLoc
    
% Created on 06/23/2017 by Benjamin Huang
    
% Construct URL 
url = ['http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/' ...
       'TideGaugeDetails/',num2str(stationId)]
% Download html source
wbpg = webread(url);
% Split file in half (speed improvement?)
wbpg = regexp(wbpg,'<h3>Harmonics Constants</h3>','split');
location = parseLoc('string',wbpg{1});
coeffs = parseCoeffs('string',wbpg{2});