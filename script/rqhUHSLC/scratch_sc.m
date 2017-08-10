%% Load the data
[time,ssh,loc] = saveRange;

%% Put all times in one array
timeT = cellfun(@(x) x', time,'UniformOutput',0);
allTime = [timeT{:}];

%% Look at the distribution
[nums,edges] = histcounts(allTime,75);
% Find highest density 
[val,ind] = max(nums);
edg1 = edges(ind);
edg2 = edges(ind + 1);

%% Plot the Data
for k=1:length(all)
    fig = figure(1);
    plot(time{k},ssh{k});
    % Format it
    grid on;
    grid minor;
    axis tight;
    xlabel('Time');
    ylabel('Tide height (millimeters)');
end
