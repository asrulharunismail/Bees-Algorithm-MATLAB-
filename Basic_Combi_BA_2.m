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
MaxEval = 1000000;
n = 40; nep = 40;               
recruitment = round(linspace(nep,1,n));
assigntment = linspace(0,1,n);
ColonySize = sum(recruitment);        % total number of foragers
MaxIt = round(MaxEval/ColonySize);    % Maximum Number of Iterations
%% Initialization
Unknown_Patch.Position = [];
Unknown_Patch.Cost = [];
Unknown_Patch.counter = [];
Scout = repmat(Unknown_Patch,n,1);
counter = 0;
% Generate Initial Solutions
for i = 1:n
    Scout(i).Position = randperm(Dims);
    Scout(i).Cost = ObjFunction(Scout(i).Position);
    counter = counter+1;
    Scout(i).counter = counter;
end
size = linspace(1,1,n);

%% Sites Selection 
[~, RankOrder] = sort([Scout.Cost]);
Patch = Scout(RankOrder);

%% Bees Algorithm Local and Global Search
for it = 1:MaxIt
    if counter >= MaxEval
        break;
    end
    % All Sites (Exploitation and Exploration)
    for i = 1:n
        bestWorker.Cost = inf;
        assigntment = D_Triangular (0,size(i),1,1,recruitment(i));
        for j = 1:recruitment(i)
            Worker.Position = Foraging_Combi_2 (Patch(i).Position,assigntment(j)* Dims);
            Worker.Cost = ObjFunction(Worker.Position);
            counter = counter+1;
            Worker.counter = counter;
            if Worker.Cost < bestWorker.Cost
                bestWorker = Worker;
            end
        end
        if bestWorker.Cost<Patch(i).Cost
            Patch(i) = bestWorker;
        end
    end
    % SORTING
    [~, RankOrder] = sort([Patch.Cost]);
    Patch = Patch(RankOrder);
    % Update Best Solution Ever Found
    OptSol = Patch(1);
    % taking of result
    OptCost(it) = OptSol.Cost;
    Counter(it) = counter;
    Time(it) = toc;
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(OptCost(it)) ' --> Time = ' num2str(Time(it)) ' seconds' '; Fittness Evaluations = ' num2str(Counter(it))]);
    
    figure(1);
    PlotSolution(OptSol.Position,Instance);
end

%% Results
figure;
semilogy(OptCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

