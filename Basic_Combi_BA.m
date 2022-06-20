clc;
clear;
close all;
tic

%% Problem Definition
[typeOfFunction] = 'Eil51'; %{'A280','Att532','Berlin52','Eil51','Eil76',
% 'Fl1577','KroA100','KroA150','KroA200','KroB100','KroB150','KroB200',
% 'KroC100','KroD100','KroE100','Lin318','Pcb442','Pr76','Rat99','Rat783',
% 'St70'}
Instance = Tsplib(typeOfFunction);
Dims = Instance.dim;
ObjFunction = @(x) Instance.evaluation(x);% Objective Function
VarSize = [1 Dims];                       % Decision Variables Matrix Size

%% Bees Algorithm Parameters
n = 40; m = 20; e = 2; nep = 40; nsp = 20;

MaxEval = 500000; accuracy = 0.001;
MaxIt = 1000;

%% Initialization
Unknown_Patch.Position = [];
Unknown_Patch.Cost = [];
Unknown_Patch.counter = [];
Scout = repmat(Unknown_Patch,n,1);
counter = 0;
% Generate Initial Solutions
for i=1:n
    Scout(i).Position = randperm(Dims);
    Scout(i).Cost = ObjFunction(Scout(i).Position);
    counter = counter+1;
    Scout(i).counter = counter;
end

%% Sites Selection 
[~, RankOrder] = sort([Scout.Cost]);
Patch = Scout(RankOrder);
BestSol.Cost = inf;

%% Bees Algorithm Local and Global Search
for it = 1:MaxIt
    if counter >= MaxEval
        break;
    end
    % Lokal Search elite
    for i = 1:e
        bestWorker.Cost = inf;
        for j = 1:nep
            Worker.Position = Foraging_Combi(Patch(i).Position);
            Worker.Cost = ObjFunction(Worker.Position);
            counter = counter+1;
            Worker.counter = counter;
            if Worker.Cost < bestWorker.Cost
                bestWorker = Worker;
            end
        end
        if bestWorker.Cost < Patch(i).Cost
            Patch(i) = bestWorker;
        end
    end
    % Lokal Search selected non-elite
    for i = e+1:m
        bestWorker.Cost = inf;
        for j=1:nsp
            Worker.Position = Foraging_Combi(Patch(i).Position);
            Worker.Cost = ObjFunction(Worker.Position);
            counter = counter+1;
            Worker.counter = counter;
            if Worker.Cost < bestWorker.Cost
                bestWorker=Worker;
            end
        end
        if bestWorker.Cost < Patch(i).Cost
            Patch(i) = bestWorker;
        end
    end
    % Global Search non-selected
    for i = m+1:n
        Patch(i).Position = randperm(Dims);
        Patch(i).Cost = ObjFunction(Patch(i).Position);
        counter = counter+1;
        Patch(i).counter = counter;
    end
    % SORTING
    [~, RankOrder] = sort([Patch.Cost]);
    Patch = Patch(RankOrder);
    % Update Best Solution Ever Found
    OptSol = Patch(1);
    if OptSol.Cost < BestSol.Cost
        BestSol=OptSol;
    end
    % taking of result
    OptCost(it) = BestSol.Cost;
    Counter(it) = counter;
    Time(it) = toc;
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(OptCost(it)) ' --> Time = ' num2str(Time(it)) ' seconds' '; Fittness Evaluations = ' num2str(Counter(it))]);
    if(abs(Instance.optima-BestSol.Cost) <= accuracy) 
        break;
    end

    figure(1);
    PlotSolution(OptSol.Position,Instance);
end
%% Results
figure;
semilogy(OptCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');