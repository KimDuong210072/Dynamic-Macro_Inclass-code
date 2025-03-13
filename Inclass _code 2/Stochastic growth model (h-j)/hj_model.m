%% File Info.

%{

    model.m
    -------
    This code sets up the model.

%}

%% Model class.

classdef hj_model
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
            par.sigma_eps = 0.07; % Std. dev of productivity shocks.
            par.rho = 0.85; % Persistence of AR(1) process.
            par.mu = 0.0; % Intercept of AR(1) process.

  
            assert(par.beta > 0 && par.beta < 1.00,'Discount factor should be between 0 and 1.\n')
            assert(par.sigma >= 1,'CRRA should be at least 1.\n')
            assert(par.y_bar > 0,'labor income should be larger than 0\n')
            assert(par.k > 0 && par.k < 1.00,'Pension fraction should be between 0 and 1.\n')
            assert(par.sigma_eps > 0,'The standard deviation of the shock must be positive.\n')
            assert(abs(par.rho) < 1,'The persistence must be less than 1 in absolute value so that the series is stationary.\n')
             %% Simulation parameters.

            par.seed = 2025; % Seed for simulation.
            par.T = 60; % Number of time periods.
            par.t_r = 41; %Number of retirement. 

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
                       
            %% Discretized productivity process.
            par.ylen = 300; % Grid size for yt.      
            par.m = 3; % Scaling parameter for Tauchen.
            assert(par.m > 0,'Scaling parameter for Tauchen should be positive.\n')
            assert(par.ylen > 3,'Grid size for y should be positive and greater than 3.\n')

            [ygrid,pmat] = hj_model.tauchen(par.mu,par.rho,par.sigma_eps,par.ylen,par.m); % Tauchen's Method to discretize the AR(1) process for log productivity.
            par.ygrid = exp(ygrid); % The AR(1) is in logs so exponentiate it to get y.
            par.pmat = pmat; % Transition matrix.

        end
        
        %% Tauchen's Method
        
        function [y,pi] = tauchen(mu,rho,sigma,N,m)
            %% Construct equally spaced grid.
        
            ar_mean = mu/(1-rho); % The mean of a stationary AR(1) process is mu/(1-rho).
            ar_sd = sigma/((1-rho^2)^(1/2)); % The std. dev of a stationary AR(1) process is sigma/sqrt(1-rho^2)
            
            y1 = ar_mean-(m*ar_sd); % Smallest grid point is the mean of the AR(1) process minus m*std.dev of AR(1) process.
            yn = ar_mean+(m*ar_sd); % Largest grid point is the mean of the AR(1) process plus m*std.dev of AR(1) process.
            
	        y = linspace(y1,yn,N); % Equally spaced grid.
            d = y(2)-y(1); % Step size.
	        
	        %% Compute transition probability matrix from state j (row) to k (column).
        
            ymatk = repmat(y,N,1); % States next period.
            ymatj = mu+rho*ymatk'; % States this period.
        
	        pi = normcdf(ymatk,ymatj-(d/2),sigma) - normcdf(ymatk,ymatj+(d/2),sigma); % Transition probabilities to state 2, ..., N-1.
	        pi(:,1) = normcdf(y(1),mu+rho*y-(d/2),sigma); % Transition probabilities to state 1.
	        pi(:,N) = 1 - normcdf(y(N),mu+rho*y+(d/2),sigma); % Transition probabilities to state N.
	        
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