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
        
        function sim = cake(par,sol)            
            %% Set up.
            
            wgrid = par.wgrid; % Cake size state variable.

            wpol = sol.w; % Cake size policy function.
            cpol = sol.c; % Consumption policy function.

            T = par.T; % Time periods.
            csim = zeros(par.T,1); % Container for simulated consumption.
            wsim = zeros(par.T,1); % Container for simulated cake size.
            usim = zeros(par.T,1); % Container for simulated value function.
            
            %% Begin simulation.
            
            rng(par.seed);
            w0_ind = randsample(par.wlen,1); % Initial cake size index.
            csim(1) = cpol(w0_ind); % Period 1 consumption.
            wsim(1) = wpol(w0_ind); % Period 1 cake size.
            usim(1) = model.utility(csim(1),par); % Period 1 value function.

            %% Simulate endogenous variables.

            for j = 2:T % Time loop.
                w_ind = find(wsim(j-1)==wgrid); % Find where cake size policy is on the cake size state grid.
                w_ind = w_ind(1);
                csim(j) = cpol(w_ind); % Period t consumption.
                wsim(j) = wpol(w_ind); % Period t cake size.
                usim(j) = model.utility(csim(j),par); % Period t value function.
            end

            sim = struct();
            
            sim.csim = csim; % Simulate consumption.
            sim.wsim = wsim; % Simulated cake size.
            sim.usim = usim; % Simulated utility function.
             
        end
        
    end
end