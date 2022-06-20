clc;
clear;
close all;
tic

%% Problem Definition
[typeOfFunction] = 'Sphere';
Instance = TestFunction38(typeOfFunction);  %{'Ackley_10','Griewangk_10',
% 'Griewangk_2','Rastrigin_10','Rosenbrock_10','Rosenbrock_2',
% 'Rosenbrock_4','Goldstein','Martin','Shekel_5','Easom','Schaffer_6',
% 'Schwefel_1.2','Sphere','Axis','Sum_diff_pow','Beale','Colville',
% 'Hartmann_1','Hartmann_2', 'Levy','Matyas','Perm','Zakharov',
% 'Schwefel_2.22','Schwefel_2.21', 'Quartic','Kowalik','Shekel_7',
% 'Shekel_10','Tripod','DeJong_2','Dejong_4', 'Alpine','Pathological',
% 'Masters','Step','6humpCamelBack', 'Michalewicz_5','Michalewicz_10',
% 'Branin','Weierstrass', 'Trid','Powell','MovedHyper'}

Dims = Instance.dim;
ObjFunction = @(x) Instance.evaluation( x ); % Objective Function
VarSize = [1 Dims]; % Decision Variables Matrix Size
VarMin = Instance.lowerBoundaries; % Decision Variables Lower Bound
VarMax = Instance.upperBoundaries; % Decision Variables Upper Bound
range = VarMax-VarMin;

%% Bees Algorithm Parameters
n = 10; m = 5; e = 2; nep = 20; nsp = 10; ngh = 0.1;

MaxEval = 1000000; accuracy = 0.001;
MaxIt = 3000;

%% Initialization
Unknown_Patch.Position = [];
Unknown_Patch.Cost = [];
Unknown_Patch.counter = [];
Scout = repmat(Unknown_Patch,n,1);
counter = 0;
% Generate Initial Solutions
for i = 1:n
    Scout(i).Position = unifrnd(VarMin,VarMax,VarSize);
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
            Worker.Position = Foraging (Patch(i).Position,ngh,VarMax,VarMin);
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
        for j = 1:nsp
            Worker.Position = Foraging (Patch(i).Position,ngh,VarMax,VarMin);
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
    % Global Search
    for i = m+1:n
        Patch(i).Position = unifrnd(VarMin,VarMax,VarSize);
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
        BestSol = OptSol;
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
end
%% Results
figure;
semilogy(OptCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');