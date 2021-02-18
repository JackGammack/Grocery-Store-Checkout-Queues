clear

InputVariables = readmatrix('InputVariables.csv');
NumRegularCheckoutsVec = InputVariables(:,1);
NumExpressCheckoutsVec = InputVariables(:,2);
NumSelfCheckoutsVec = InputVariables(:,3);
QueueCapacityVec = InputVariables(:,4);
SelfAndExpressMaxItemsVec = InputVariables(:,5);
TimePeriodVec = InputVariables(:,6);
SimResults = ["NumRegularCheckouts", "NumExpressCheckouts", "NumSelfCheckouts", "QueueCapacity", "SelfAndExpressMaxItems", "TimePeriod", "TotalCustomersServiced", "TotalCustomersLost", "AverageWaitTime", "AverageCustomersWaiting"];

for i = [1:length(NumRegularCheckoutsVec)]
    
    NumRegularCheckouts = NumRegularCheckoutsVec(i);
    NumExpressCheckouts = NumExpressCheckoutsVec(i);
    NumSelfCheckouts = NumSelfCheckoutsVec(i);

    QueueCapacity = QueueCapacityVec(i);
    SelfAndExpressMaxItems = SelfAndExpressMaxItemsVec(i);

    TimePeriod = TimePeriodVec(i);
    
    Inputs = [NumRegularCheckouts NumExpressCheckouts NumSelfCheckouts QueueCapacity SelfAndExpressMaxItems TimePeriod];
    
    simOut = sim('AllCheckoutsSim', 2000000);
    WaitTime = simOut.get('OverallAverageWaitTime').Data;
    CustomersWaiting = simOut.get('OverallAverageNumCustomersWaiting').Data;
    CustomersLost = simOut.get('OverallNumCustomersLost').Data;
    CustomersServiced = simOut.get('OverallNumCustomersServiced').Data;
    
    Outputs = [CustomersServiced CustomersLost WaitTime CustomersWaiting];
    NewSimResult = horzcat(Inputs,Outputs);
    
    SimResults = [SimResults; NewSimResult];
    
    
end

writematrix(SimResults,'SimResults.xls');