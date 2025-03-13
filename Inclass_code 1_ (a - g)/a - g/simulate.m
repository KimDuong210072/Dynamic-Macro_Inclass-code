%% File Info.

%{

    simulate.m
    ----------
    This code simulates the model.

%}

%% Simulate class.

classdef simulate
    methods(Static)
        %% Simulate the model. 
        
        function sim = asset(par,sol)            
            %% Set up.
            
            agrid = par.agrid; % Asset state variable.

            apol = sol.a; % Asset policy function.
            cpol = sol.c; % Consumption policy function.

            T = par.T; % Time periods.
            csim = zeros(par.T,1); % Container for simulated consumption.
            asim = zeros(par.T,1); % Container for simulated asset.
            usim = zeros(par.T,1); % Container for simulated value function.
            
            %% Begin simulation.
            
            rng(par.seed);
            a0_ind = randsample(par.alen,1); % Initial cake size index.
            csim(1) = cpol(a0_ind); % Period 1 consumption.
            asim(1) = apol(a0_ind); % Period 1 asset.
            usim(1) = model.utility(csim(1),par); % Period 1 value function.

            %% Simulate endogenous variables.

            for j = 2:T % Time loop.
                a_ind = find(asim(j-1)==agrid); % Find where cake size policy is on the cake size state grid.
                a_ind = a_ind(1);
                csim(j) = cpol(a_ind); % Period t consumption.
                asim(j) = apol(a_ind); % Period t asset.
                usim(j) = model.utility(csim(j),par); % Period t value function.
            end

            sim = struct();
            
            sim.csim = csim; % Simulate consumption.
            sim.asim = asim; % Simulated cake size.
            sim.usim = usim; % Simulated utility function.
             
        end
        
    end
end