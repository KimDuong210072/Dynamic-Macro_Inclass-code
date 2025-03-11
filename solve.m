%% Solve class.

classdef solve
    methods(Static)
        %% Solve the model using backward induction 
        
        function sol = cs_model_fin(par)            
            %% Structure array for model solution.
            
            sol = struct();
            
            %% Model parameters, grids and functions.
            
            beta = par.beta; % Discount factor.
            alen = par.alen; % Grid size for a.
            agrid = par.agrid; % Grid for a (state and choice).
            
            %% Backward Induction
            
            v1 = zeros(alen,par.T); % Container for V.
            a1 = zeros(alen,par.T); % Container for a'.
            
            fprintf('------------Beginning Backward Induction.------------\n\n')
            
            % Last period: consume everything
            v1(:,par.T) = model.utility(agrid,par); 
            a1(:,par.T) = 0; 
            
            % Solve backwards in time
            for t = par.T-1:-1:1
                for i = 1:alen % Loop over state space
                    
                    % Determine income based on working/retirement status
                    if t < par.t_r
                        income = par.y_bar; % Working income
                    else
                        income = par.y_bar * par.y_bar; % Pension
                    end
                    
                    % Consumption equation: c_t = income + a_t - a_{t+1}/(1+r)
                    c = max(income + agrid(i) - agrid./(1 + par.r), 0);
                    
                    % Bellman equation
                    vall = model.utility(c,par) + beta * v1(:,t+1); 
                    [vmax,ind] = max(vall); 
                    v1(i,t) = vmax;
                    a1(i,t) = agrid(ind);
                end
            end

            fprintf('------------End of Backward Induction.------------\n')
            
            %% Value and policy functions.
            
            sol.c = max(agrid - a1, 0); % Consumption policy function.
            sol.a = a1; % Asset policy function.
            sol.v = v1; % Value function.
        end
    end
end
