%% File Info.

%{

    model.m
    -------
    This code sets up the model.

%}

%% Model class.

classdef model
    methods(Static)
        %% Set up structure array for model parameters and set the simulation parameters.
        
        function par = setup()            
            %% Structure array for model parameters.
            
            par = struct();
            
            %% Preferences.
            
            par.beta = 0.95; % Discount factor.
            par.sigma = 1.00; % CRRA.
            
            assert(par.beta > 0 && par.beta < 1.00,'Discount factor should be between 0 and 1.\n')
            assert(par.sigma >= 1,'CRRA should be at least 1.\n')

            %% Simulation parameters.

            par.seed = 2025; % Seed for simulation.
            par.T = 50; % Number of time periods.

        end
        
        %% Generate state grids.
        
        function par = gen_grids(par)
            %% Cake grid.
             
            par.wlen = 300; % Grid size for W.
            par.wmax = 20.00; % Upper bound for W.
            par.wmin = 0.00; % Minimum W.
            
            assert(par.wlen > 5,'Grid size for W should be positive and greater than 5.\n')
            assert(par.wmax > par.wmin,'Minimum W should be less than maximum value.\n')
            
            par.wgrid = linspace(par.wmin,par.wmax,par.wlen)'; % Equally spaced, linear grid for W (and W').
                        
        end
        
        %% Utility function.
        
        function u = utility(c,par)
            %% CRRA utility
            
            if par.sigma == 1
                u = log(c); % Log utility.
            else
                u = (c.^(1-par.sigma))./(1-par.sigma); % CRRA utility.
            end
                        
        end
        
    end
end