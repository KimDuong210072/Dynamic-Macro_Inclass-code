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
        
        function sol = grow(par)            
            %% Structure array for model solution.
            
            sol = struct();
            
            %% Model parameters, grids and functions.
            
            beta = par.beta; % Discount factor.
            alpha = par.alpha; % Capital share of income.
            delta = par.delta; % Depreciation rate.

            klen = par.klen; % Grid size for k.
            kgrid = par.kgrid; % Grid for k (state and choice).

            Alen = par.Alen; % Grid size for A.
            Agrid = par.Agrid; % Grid for A.
            pmat = par.pmat; % Grid for A.

            kmat = repmat(kgrid,1,Alen); % k for each value of A.
            Amat = repmat(Agrid,klen,1); % A for each value of k.

            %% Value Function Iteration.
            
            y0 = Amat.*kmat.^alpha; % Assume you have the deterministic steady-state capital.
            i0 = delta*kgrid; % In the deterministic steady state, k=k'=k*.
            c0 = y0-i0; % Steady-state consumption in a deterministic setting.
            v0 = model.utility(c0,par)./(1-beta); % Guess of value function for each combination of k and A; each row corresponds to a given k and each column corresponds to a given A.

            v1 = zeros(klen,Alen); % Container for V.
            k1 = zeros(klen,Alen); % Container for k'.
                            
            crit = 1e-6;
            maxiter = 10000;
            diff = 1;
            iter = 0;
            
            fprintf('------------Beginning Value Function Iteration.------------\n\n')
            
            while diff > crit && iter < maxiter % Iterate on the Bellman Equation until convergence.
                
                for p = 1:klen % Loop over the k-states.
                    for j = 1:Alen % Loop over the A-states.

                        % Macro variables.
                        y = Agrid(j)*kgrid(p)^alpha; % Output given k and A, kgrid(p) and Agrid(j) respectively.
                        i = kgrid-(1-delta)*kgrid(p); % Possible values for investment, i=k'-(1-delta)k, when choosing k' from kgrid and given k.
                        c = y-i; % Possible values for consumption, c = y-i, given y and i.

                        % Solve the maximization problem.
                        ev = v0*pmat(j,:)'; %  The next-period value function is the expected value function over each possible next-period A, conditional on the current state j.
                        vall = model.utility(c,par) + beta*ev; % Compute the value function for each choice of k', given k.
                        vall(c<0) = -inf; % Set the value function to negative infinity when c < 0.
                        [vmax,ind] = max(vall); % Maximize: vmax is the maximized value function; ind is where it is in the grid.
                    
                        % Store values.
                        v1(p,j) = vmax; % Maximized v.
                        k1(p,j) = kgrid(ind); % Optimal k'.

                    end
                end
                
                diff = norm(v1-v0); % Check for convergence.
                v0 = v1; % Update guess of v.
                
                iter = iter + 1; % Update counter.
                
                % Print counter.
                if mod(iter,25) == 0
                    fprintf('Iteration: %d.\n',iter)
                end

            end
                
            fprintf('\nConverged in %d iterations.\n\n',iter)
            
            fprintf('------------End of Value Function Iteration.------------\n')
            
            %% Macro variables, value, and policy functions.
            
            sol.y = Amat.*kmat.^alpha; % Output.
            sol.k = k1; % Capital policy function.
            sol.i = k1-((1-delta).*kmat); % Investment policy function.
            sol.c = sol.y-sol.i; % Consumption policy function.
            sol.v = v1; % Value function.
            
        end
        
    end
end