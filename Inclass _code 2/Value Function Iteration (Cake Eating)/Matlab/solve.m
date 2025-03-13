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
            wlen = par.wlen; % Grid size for W.
            wgrid = par.wgrid; % Grid for W (state and choice).

            %% Value Function Iteration.
            
            v0 = model.utility(par.wgrid,par)./(1-beta); % Guess of value function.
            %v0 = zeros(wlen,1);

            v1 = zeros(wlen,1); % Container for V.
            w1 = zeros(wlen,1); % Container for W'.
                            
            crit = 1e-6;
            maxiter = 10000;
            diff = 1;
            iter = 0;
            
            fprintf('------------Beginning Value Function Iteration.------------\n\n')
            
            while diff > crit && iter < maxiter % Iterate on the Bellman Equation until convergence.
                
                for i = 1:wlen % Loop over the state space and maximize.
                    c = wgrid(i)-wgrid; % Consumption, c = W-W', for a given state of W, wgrid(i), and the vector of choices for W', wgrid.
                    vall = model.utility(c,par) + beta*v0; % Compute the Bellman equation for each choice of W', given a particular state of W.
                    vall(c<=0) = -inf; % Set the value function to negative infinity when c <= 0.
                    [vmax,ind] = max(vall); % Note that wgrid(i)-wgrid is W-W', where W' is a vector.
                    v1(i) = vmax;
                    w1(i) = wgrid(ind);
                end
                
                diff = norm(v1-v0); % Check convergence.
                v0 = v1; % Update guess.
                
                iter = iter + 1; % Update counter.
                
                % Print counter.
                if mod(iter,25) == 0
                    fprintf('Iteration: %d.\n',iter)
                end

            end
                
            fprintf('\nConverged in %d iterations.\n\n',iter)
            
            fprintf('------------End of Value Function Iteration.------------\n')
            
            %% Value and policy functions.
            
            sol.c = max(wgrid-w1,0); % Consumption policy function.
            sol.w = w1; % Cake size policy function.
            sol.v = v1; % Value function.
            
        end
        
    end
end