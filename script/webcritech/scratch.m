% THIS SCRIPT IS FOR TESTING MATLAB CODE BEFORE FUNCTIONALIZING
% IT/FORMALIZING IT. 


%%

% Get prediction data from webcritech
[loc,har,sumHar] = getWebcritechPred('stationIDs.txt');

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

% Save
orient(fig,'Landscape');
saveas(fig,'stemSummedCoeff.pdf');

%%
a = 2;
c = 2;
syms u v
x = a*cos(u)*sin(v);
y = a*sin(u)*sin(v);
z = c*cos(v);
colormap summer;
f = fsurf(x,y,z,'EdgeColor','none');
f.MeshDensity = 9;

for k=1:0.1:10
    f.ZFunction = k*c*cos(v);
    drawnow
end

%%
figure('Position',[100 100 850 1100]);
a = (sumHar' - min(sumHar'))./(max(sumHar') - min(sumHar'));
%plot(har(1,:,2),a); hold on; grid on; axis tight;
plot(har(1,:,2),nanmedian(a,2),'k','LineWidth',3);hold on; grid on; axis tight;
%plot(har(1,:,2),nanmedian(a,2)-nanstd(a,1,2));
plot(har(1,:,2),nanmedian(a,2)+nanstd(a,1,2));
set(gca,'xscale','log');
set(gca,'yscale','log');

xlabel('Period (days)','FontSize',15);
ylabel('Normalized Summed Coefficient (a.u.)','FontSize',15);

