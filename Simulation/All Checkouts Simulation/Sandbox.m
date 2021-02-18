% SET THESE PARAMETERS BEFORE RUNNING SIMULATION

NumRegularCheckouts = 7; % Between 1 and 15
NumExpressCheckouts = 2; % Between 0 and 15
NumSelfCheckouts = 2; % Between 0 and 15
% 
QueueCapacity = 7; % Same for all types of Checkouts
SelfAndExpressMaxItems = 10; % Item limit on Self and Express Checkouts
% 
TimePeriod = 1; % 1 for peak, 2 for mornings, 3 for evenings

AmountSelfCheckoutEligible = 0.3; % Between 0 and 1. Higher means more customers
                                 % will be willing to do self checkout
                                 % rather than regular checkout if they are
                                 % under the item limit. From the data,
                                 % about 30% is right.

showFigures = false; % change to true if you want to see Distribution figures

% DO NOT EDIT BEYOND THIS LINE

% This file reads the checkout data and creates probability
% distributions to describe the Arrival Times, Checkout Times, and Numbers
% of Items that can be randomly sampled for the simulation

if NumRegularCheckouts == 0
    NumRegularCheckoutsHelper = 1;
else
    NumRegularCheckoutsHelper = NumRegularCheckouts;
end

if NumExpressCheckouts == 0
    NumExpressCheckoutsHelper = 1;
else
    NumExpressCheckoutsHelper = NumExpressCheckouts;
end

if NumSelfCheckouts == 0
    NumSelfCheckoutsHelper = 1;
else
    NumSelfCheckoutsHelper = NumSelfCheckouts;
end

% Read all grocery store data from csv files
AllCheckouts = readmatrix('AllCheckouts.csv');
RegularCheckouts = readmatrix('RegularCheckouts.csv');
SelfCheckouts = readmatrix('SelfCheckouts.csv');
MorningTimes = readmatrix('MorningArrivalTimes.csv');
EveningTimes = readmatrix('EveningArrivalTimes.csv');

AllNumberOfItems = AllCheckouts(:,2);
AllServiceTimes = AllCheckouts(:,3);
AllTimesBetweenArrivals = AllCheckouts(:,4);
MorningTimesBetweenArrivals = MorningTimes(:,1);
EveningTimesBetweenArrivals = EveningTimes(:,1);

if TimePeriod == 1
    TimesBetweenArrivals = AllTimesBetweenArrivals;
elseif TimePeriod == 2
    TimesBetweenArrivals = MorningTimesBetweenArrivals;
else
    TimesBetweenArrivals = EveningTimesBetweenArrivals;
end

% Sets arrival times to all be positive
for n = 1:length(TimesBetweenArrivals)
    if TimesBetweenArrivals(n) == 0
        TimesBetweenArrivals(n) = 0.01;
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
% Only includes service times for customers with items below the limit
for i = [1:length(SelfNumberOfItems)]
    if( SelfNumberOfItems(i) <= SelfAndExpressMaxItems )
        SelfServiceTimes(ctrUnderMaxItems,1) = SelfServiceTimesWithoutLimit(i);
        ctrUnderMaxItems = ctrUnderMaxItems + 1;
    end
end

ExpressServiceTimesWithoutLimit = RegularServiceTimes;
ExpressServiceTimes = [];
ctrUnderMaxItems = 1;
% Only includes service times for customers with items below the limit
for i = [1:length(RegularNumberOfItems)]
    if( RegularNumberOfItems(i) <= SelfAndExpressMaxItems )
        ExpressServiceTimes(ctrUnderMaxItems,1) = RegularServiceTimes(i);
        ctrUnderMaxItems = ctrUnderMaxItems + 1;
    end
end

ctrOverMaxItems = 1;
RegularServiceTimesOverLimit = [];
for i = [1:length(RegularNumberOfItems)]
    if( RegularNumberOfItems(i) > SelfAndExpressMaxItems )
        RegularServiceTimesOverLimit(ctrOverMaxItems,1) = RegularServiceTimes(i);
        ctrOverMaxItems = ctrOverMaxItems + 1;
    end
end

%if NumExpressCheckouts > 0
if 1
    RegularServiceTimes = RegularServiceTimesOverLimit;
end

% Fit Kernel Probability Distribution to data
ArrivalTimesDist = fitdist(TimesBetweenArrivals,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandArrivalTimesDist = random(ArrivalTimesDist, length(TimesBetweenArrivals), 1);
% Figure 1 shows distribution of Arrival Times for all customers
if showFigures
    figure(1)
    clf
    histEdges = [0:2:max(TimesBetweenArrivals)+1];
    % Plot histogram of actual data
    histogram(TimesBetweenArrivals, histEdges)
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
    histEdges = [0:5:max(AllNumberOfItems)+1];
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
    histEdges = [0:10:max(RegularServiceTimes)+1];
    % Plot histogram of actual data
    histogram(RegularServiceTimes, histEdges)
    hold on
    histogram(RandRegularServiceTimesDist, histEdges);
    title("Non-Express Checkout Service Time Distribution");
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
    histEdges = [0:10:max(SelfServiceTimes)+1];
    % Plot histogram of actual data
    histogram(SelfServiceTimes, histEdges)
    hold on
    histogram(RandSelfServiceTimesDist, histEdges);
    title("Self Checkout Time Distribution");
    xlabel("Service Time (s)");
    ylabel("Frequency");
    legend("Actual Self Service Times","Fitted Distribution Self Service Times");
end
% RandSelfServiceTimesDist contains a large random sample of self service times from
% the Kernel distribution

% Fit Kernel Probability Distribution to data
ExpressServiceTimesDist = fitdist(ExpressServiceTimes,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandExpressServiceTimesDist = random(ExpressServiceTimesDist, length(ExpressServiceTimes), 1);
if showFigures
    % Figure 5 shows distribution of Service Times for Express Checkouts
    figure(5)
    clf
    histEdges = [0:10:max(ExpressServiceTimes)+1];
    % Plot histogram of actual data
    histogram(ExpressServiceTimes, histEdges)
    hold on
    histogram(RandExpressServiceTimesDist, histEdges);
    title("Express Service Time Distribution");
    xlabel("Express Service Time (s)");
    ylabel("Frequency");
    legend("Actual Express Service Times","Fitted Distribution Express Service Times");
end
% RandExpressServiceTimesDist contains a large random sample of express service times from
% the Kernel distribution

% Fit Kernel Probability Distribution to data
AllServiceTimesDist = fitdist(AllServiceTimes,'Kernel','Support','positive');
% Randomly sample from this distribution and plot the histogram
RandAllServiceTimesDist = random(AllServiceTimesDist, length(AllServiceTimes), 1);
if showFigures
    % Figure 3 shows distribution of Service Times for Regular Checkouts
    figure(6)
    clf
    histEdges = [0:10:max(AllServiceTimes)+1];
    % Plot histogram of actual data
    histogram(AllServiceTimes, histEdges)
    hold on
    histogram(RandAllServiceTimesDist, histEdges);
    title("Regular Checkout Service Time Distribution");
    xlabel("Service Time (s)");
    ylabel("Frequency");
    legend("Actual Service Times","Fitted Distribution Service Times");
end
% RandRegularServiceTimesDist contains a large random sample of service times from
% the Kernel distribution

MeanArrivalTime = mean(RandArrivalTimesDist);
MeanRegularServiceTime = mean(RegularCheckouts(:,2));
MeanNonExpressServiceTime = mean(RandRegularServiceTimesDist);
MeanSelfServiceTime = mean(RandSelfServiceTimesDist);
MeanExpressServiceTime = mean(RandExpressServiceTimesDist);
% In order to stop the queue from increasing infinitely, the minimum number
% of servers must be greater than the proportion of mean service time to
% mean arrival time
MinimumNumberOfServers = MeanRegularServiceTime / MeanArrivalTime;
