%% File Info.

%{

    solve.m
    -------
    This code solves the model.

%}

%% Solve class.

classdef solve
    methods(Static)
        %% Solve the model using VFI. 
        
        function sol = cs_model_inf(par)            
            %% Structure array for model solution.
            
            sol = struct();
            
            %% Model parameters, grids and functions.
            
            beta = par.beta; % Discount factor.
            alen = par.alen; % Grid size for a.
            agrid = par.agrid; % Grid for a (state and choice).

            %% Value Function Iteration.
            
            v0 = model.utility(par.agrid,par)./(1-beta); % Guess of value function.
            %v0 = zeros(wlen,1);

            v1 = zeros(alen,par.T); % Container for V.
            a1 = zeros(alen,par.T); % Container for a'.
                            
            crit = 1e-6;
            maxiter = 10000;
            diff = 1;
            iter = 0;
            
            fprintf('------------Beginning Value Function Iteration.------------\n\n')
            
       
                
                for t = par.T:1
                    for i = 1:alen % Loop over the state space and maximize.
                        c = (-(agrid)/(1+r)) + agrid(i) + par.y_bar ; % Consumption for a given state of a, agrid(i), and the vector of choices for a', agrid.
                        vall = model.utility(c,par) + beta*v0; % Compute the Bellman equation for each choice of a', given a particular state of a.
                        [vmax,ind] = max(vall); 
                        v1(i,t) = vmax;
                        a1(i,t) = agrid(ind);
                    end
                end
                
                

            end
                
            
            fprintf('------------End of Value Function Iteration.------------\n')
            
            %% Value and policy functions.
            
            sol.c = max(agrid-a1,0); % Consumption policy function.
            sol.a = a1; % Cake size policy function.
            sol.v = v1; % Value function.
            
        end
        
    end
end