% Load data 
path2data = '~/research/data/processed/webcritech/';
load([path2data 'webcritechHar.mat']);
load([path2data 'webcritechStationLoc.mat']);
load([path2data 'webcritechSumHar.mat']);

% Remove 0 component
har2 = har(:,:,2:4);

% Sum constants
for k=length(ids)
    sumHar(k,1:70) = sqrt(har2(k,:,2).^2+har2(k,:,3).^2);
end

fig = figure('Position',[100 100 1000 775]);
%stem(har(1,:,2),sumHar'); hold on; grid on; axis tight;
hold on; grid on; axis tight;
errorbar(har(1,:,2),nanmedian(sumHar),mad(sumHar,1),'o');
stem(har(1,:,2),nanmedian(sumHar));
set(gca,'xscale','log');
set(gca,'yscale','log');
xlabel('Period (days)');
ylabel('Normalized Summed Coefficient (a.u.)');
