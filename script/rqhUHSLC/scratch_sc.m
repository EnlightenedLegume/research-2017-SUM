%% Load the data
[time,ssh,loc] = saveRange;

%% 


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
