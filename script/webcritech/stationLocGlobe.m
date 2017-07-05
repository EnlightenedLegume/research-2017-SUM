% Plots globe with stations on it

grs80 = referenceEllipsoid('grs80','km');
figure('Renderer','opengl')
ax = axesm('sinusoid');
axis equal off

load topo
geoshow(topo,topolegend,'DisplayType','texturemap')
demcmap(topo)
land = shaperead('landareas','UseGeoCoords',true);
plotm([land.Lat],[land.Lon],'Color','black')
rivers = shaperead('worldrivers','UseGeoCoords',true);
plotm([rivers.Lat],[rivers.Lon],'Color','blue')
plotm(loc(:,1),loc(:,2),'^k');