function coeffs = parseWebcritechCoeffs(stationid)
% Used for parsing harmonic constants from the eu website
% Webcritech. Base URL is
% http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/TideGaugeDetails
% VARIABLES:
% stationid    int    Station number that is appended onto the end
%                      of the url
% Created 2017/06/22 by Benjamin Huang

url = ['http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/' ...
              'TideGaugeDetails/' num2str(stationid)]
tg = webread(url);
tg = regexp(tg,'<h3>Harmonics Constants</h3>','split');
tg = tg{2};
tgNoW = regexprep(tg,'\s*','');
exp = ['<tdclass="text-centertext-grid">[^<]*</td><tdclass="text-' ...
       'righttext-grid">[^<]*</td><tdclass="text-righttext-grid">' ...
       '[^<]*</td><tdclass="text-righttext-grid">[^<]*</td>'];
tg1 = regexp(tgNoW,exp,'match');
coeffsStr = regexp(tg1,'\d+\.?\d*(E[+-]\d*)?','match');
coeffs = reshape(cell2mat(cellfun(@(x) cellfun(@str2num,x),coeffsStr, ...
                                  'UniformOutput',false)),4,[])';