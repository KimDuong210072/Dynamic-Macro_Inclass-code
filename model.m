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
            par.y_bar = 3.50; %set y_bar
            par.k = 0.3;
            par.r = 0.15;

            assert(par.beta > 0 && par.beta < 1.00,'Discount factor should be between 0 and 1.\n')
            assert(par.sigma >= 1,'CRRA should be at least 1.\n')
            assert(par.y_bar > 0,'labor income should be larger than 0\n')
            assert(par.k > 0 && par.k < 1.00,'Pension fraction should be between 0 and 1.\n')

           

            %% Simulation parameters.

            par.seed = 2025; % Seed for simulation.
            par.T = 4; % Number of time periods.
            par.t_r = 3; %Number of retirement. 

        end
        
        %% Generate state grids.
        
        function par = gen_grids(par)
            %% Cake grid.
             
            par.alen = 300; % Grid size for a.
            par.amax = 20.00; % Upper bound for a.
            par.amin = 0.00; % Minimum a.
            
            assert(par.alen > 5,'Grid size for a should be positive and greater than 5.\n')
            assert(par.amax > par.amin,'Minimum a should be less than maximum value.\n')
            
            par.agrid = linspace(par.amin,par.amax,par.alen)'; % Equally spaced, linear grid for a (and a').
                        
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