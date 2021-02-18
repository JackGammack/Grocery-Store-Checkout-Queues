clear

% SET THESE PARAMETERS BEFORE RUNNING SIMULATION

TimePeriod = 1; % 1 for peak, 2 for off-peak, 3 for dead
RegularQueueCapacity = 7;
SelfQueueCapacity = 5;
NumRegularCheckouts = 15; % Between 1 and 15
NumExpressCheckouts = 0;
SelfCheckoutMaxItems = 100;
showFigures = true;

% This file reads the checkout data and creates probability
% distributions to describe the Arrival Times, Checkout Times, and Numbers
% of Items that can be randomly sampled for the simulation

% Read all grocery store data from csv files
AllCheckouts = readmatrix('AllCheckouts.csv');
RegularCheckouts = readmatrix('RegularCheckouts.csv');
SelfCheckouts = readmatrix('SelfCheckouts.csv');

AllNumberOfItems = AllCheckouts(:,2);
AllServiceTimes = AllCheckouts(:,3);
AllTimesBetweenArrivals = AllCheckouts(:,4);

% Sets arrival times to all be positive
for n = 1:length(AllTimesBetweenArrivals)
    if AllTimesBetweenArrivals(n) == 0
        AllTimesBetweenArrivals(n) = 0.01;
    end
end

% Sets number of items to all be positive
for n = 1:length(AllNumberOfItems)
    if AllNumberOfItems(n) == 1
        AllNumberOfItems(n) = 1.01;
    end
end

RegularNumberOfItems = RegularCheckouts(:,1);
RegularServiceTimes = RegularCheckouts(:,2);

SelfNumberOfItems = SelfCheckouts(:,1);
SelfServiceTimesWithoutLimit = SelfCheckouts(:,2);
SelfServiceTimes = [];
ctrUnderMaxItems = 1;
for i = [1:length(SelfNumberOfItems)]
    if( SelfNumberOfItems(i) <= SelfCheckoutMaxItems )
        SelfServiceTimes(ctrUnderMaxItems,1) = SelfServiceTimesWithoutLimit(i);
        ctrUnderMaxItems = ctrUnderMaxItems + 1;
    end
end

% Fit Kernel Probability Distribution to data
ArrivalTimesDist = fitdist(AllTimesBetweenArrivals,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandArrivalTimesDist = random(ArrivalTimesDist, length(AllTimesBetweenArrivals), 1);
% Figure 1 shows distribution of Arrival Times for all customers
if showFigures
    figure(1)
    clf
    histEdges = [0:1:max(AllTimesBetweenArrivals)+1];
    % Plot histogram of actual data
    histogram(AllTimesBetweenArrivals, histEdges)
    hold on
    histogram(RandArrivalTimesDist, histEdges);
    title("Arrival Time Distribution");
    xlabel("Time Between Arrivals (s)");
    ylabel("Frequency");
    legend("Actual Times","Fitted Distribution Times");
end
% RandArrivalTimesDist contains a large random sample of arrival times from
% the Kernel distribution


% Fit Kernel Probability Distribution to data
ItemsDist = fitdist(AllNumberOfItems,'Kernel','Support',[1 1000]);
% Randomly sample from this distribution and plot the histogram
RandItemsDist = random(ItemsDist, length(AllNumberOfItems), 1);
if showFigures
    % Figure 2 shows distribution of Numbers of Items for all customers
    figure(2)
    clf
    histEdges = [-3:1:max(AllNumberOfItems)+1];
    % Plot histogram of actual data
    histogram(AllNumberOfItems, histEdges)
    hold on
    histogram(RandItemsDist, histEdges);
    title("Number of Items Distribution");
    xlabel("Number of Items");
    ylabel("Frequency");
    legend("Actual Number of Items","Fitted Distribution Number of Items");
end
% RandItemsDist contains a large random sample of numbers of items from
% the Kernel distribution


% Fit Kernel Probability Distribution to data
RegularServiceTimesDist = fitdist(RegularServiceTimes,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandRegularServiceTimesDist = random(RegularServiceTimesDist, length(RegularServiceTimes), 1);
if showFigures
    % Figure 3 shows distribution of Service Times for Regular Checkouts
    figure(3)
    clf
    histEdges = [0:5:max(RegularServiceTimes)+1];
    % Plot histogram of actual data
    histogram(RegularServiceTimes, histEdges)
    hold on
    histogram(RandRegularServiceTimesDist, histEdges);
    title("Regular Checkout Service Time Distribution");
    xlabel("Service Time (s)");
    ylabel("Frequency");
    legend("Actual Service Times","Fitted Distribution Service Times");
end
% RandRegularServiceTimesDist contains a large random sample of service times from
% the Kernel distribution


% Fit Kernel Probability Distribution to data
SelfServiceTimesDist = fitdist(SelfServiceTimes,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandSelfServiceTimesDist = random(SelfServiceTimesDist, length(SelfServiceTimes), 1);
if showFigures
    % Figure 4 shows distribution of Service Times for Self Checkouts
    figure(4)
    clf
    histEdges = [0:5:max(SelfServiceTimes)+1];
    % Plot histogram of actual data
    histogram(SelfServiceTimes, histEdges)
    hold on
    histogram(RandSelfServiceTimesDist, histEdges);
    title("Self Service Time Distribution");
    xlabel("Self Service Time (s)");
    ylabel("Frequency");
    legend("Actual Self Service Times","Fitted Distribution Self Service Times");
end
% RandSelfServiceTimesDist contains a large random sample of self service times from
% the Kernel distribution

MeanArrivalTime = mean(RandArrivalTimesDist);
MeanRegularServiceTime = mean(RandRegularServiceTimesDist);
MeanSelfServiceTime = mean(RandSelfServiceTimesDist);
% In order to stop the queue from increasing infinitely, the minimum number
% of servers must be greater than the proportion of mean service time to
% mean arrival time
MinimumNumberOfServers = MeanRegularServiceTime / MeanArrivalTime;

% This last section is from me unsuccessfully attempting to make a 2D
% probability distribution based on both NumberOfItems and ServiceTime.
% Please ignore
%figure(4)
%clf
%X = [AllNumberOfItems, AllServiceTimes];
%hist3(X, 'edges', {0:5:max(AllNumberOfItems)+1 0:10:max(AllServiceTimes)+1});
%scatter( AllNumberOfItems, AllServiceTimes );
% gridx1 = 0:1:max(AllNumberOfItems);
% gridx2 = 0:5:max(AllServiceTimes);
% [x1,x2] = meshgrid(gridx1, gridx2);
% x1 = x1(:);
% x2 = x2(:);
% xi = [x1 x2];
% 
% x = [AllNumberOfItems AllServiceTimes];
% 
% ksdensity(x,xi);
