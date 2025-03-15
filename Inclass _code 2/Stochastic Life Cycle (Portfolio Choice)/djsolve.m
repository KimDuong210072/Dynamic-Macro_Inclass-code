%% File Info.

%{

    djsolve.m
    -------
    This code solves the model.

%}

%% Solve class.

classdef djsolve
    methods(Static)
        %% Solve the model using BI. 
        
        function sol = lc(par)            
            %% Structure array for model solution.
            
            sol = struct();
            
            %% Model parameters, grids and functions.
            
            T = par.T; % Last period of life.
            tr = par.tr; % First year of retirement.

            beta = par.beta; % Discount factor.

            alen = par.alen; % Grid size for a.
            agrid = par.agrid; % Grid for a (state and choice).
            
            ylen = par.ylen; % Grid size for y.
            ygrid = par.ygrid; % Grid for y.
            pmat = par.pmat; % Transition matrix for y.

            rbar = par.rbar; % Safe asset fixed interest rate.
            kappa = par.kappa; % Share of income as pension.

            alphalen = par.alphalen; % Grid size for alpha.
            alphagrid = par.alphagrid; % Grid for alpha (state and choice).

            %% Backward induction.
            
            v1 = nan(alen,T,ylen,alphalen); % Container for V.
            a1 = nan(alen,T,ylen,alphalen); % Container for a'.
            c1 = nan(alen,T,ylen,alphalen); % Container for c'.
            alpha1 = nan(alen,T,ylen,alphalen); % Container for alpha'.


            % amat will have dimensions: (alen x 1 x ylen x alphalen)
            amat = repmat(reshape(agrid, [alen, 1, 1, 1]), [1, 1, ylen, alphalen]);
            % ymat will have dimensions: (alen x 1 x ylen x alphalen) where each row is ygrid.
            ymat = repmat(reshape(ygrid, [1, 1, ylen, 1]), [alen, 1, 1, alphalen]);
            
            fprintf('------------Solving from the Last Period of Life.------------\n\n')
            
            for age = 1:T % Start in the last period and iterate backward.
                
                if T-age+1 == T % Last period of life.

                    c1(:,T,:,:) = amat + kappa*ymat; % Consume everything.
                    a1(:,T,:,:) = 0.0; % Save nothing.
                    v1(:,T,:,:) = djmodel.utility(c1(:,T,:,:),par); % Terminal value function.
                    alpha1(:,T,:,:) = 0.0; %Invest nothing. 

                else % All other periods.
    
                    for i = 1:ylen % Loop over the y-states.

                        if T-age+1 >= tr % Workers get a salary; retirees get a pension proportional to last drawn salary.
                            yt = kappa*ygrid(i);
                        else
                            yt = ygrid(i);
                        end
                        for al = 1:alphalen % Loop over the alpha choices.
                                alpha_t = alphagrid(al);
        
                            for p = 1:alen % Loop over the a-states.
                                R_t  = alpha_t*(1 + rbar) + (1 - alpha_t)*(1 + par.r_t);

                                if p < alen
                                    next = agrid(p+1);
                                else
                                    next = agrid(p); % When at the upper bound, no higher asset is available.
                                end
                            % Consumption
                            ct = agrid(p) + yt - (next ./ R_t); % Possible values for consumption, c = a + y - (a'/(1+r)), given a and y.
                            ct(ct<0.0) = 0.0;

                            
                            % Initialize the next-period expected value.
                                EV_next = 0.0;
                                
                                % Loop over next-period income states.
                                for yNext = 1:ylen
                                    probY = pmat(i, yNext);  % Correctly index pmat by the current income state.
                                    % For each next income state, take the best next-period value over alpha:
                                    [vmaxNext, ~] = max(squeeze(v1(p,T-age+2, yNext, :)));
                                    EV_next = EV_next + probY * vmaxNext;
                                end

                            % Solve the maximization problem.
                            vall = djmodel.utility(ct, par) + beta * EV_next; % Compute the value function for each choice of a', given a.
                            vall(agrid+1<0.0) = -inf; % Set the value function to negative infinity when at < 0.
                            vall(ct<=0.0) = -inf; % Set the value function to negative infinity when c <= 0.
                            [vmax, ind] = max(vall(:)); % Maximize: vmax is the maximized value function; ind is where it is in the grid.
                            
                            % Store values.
                            v1(p,T-age+1,i,al) = vmax; % Maximized v.
                            c1(p,T-age+1,i,al) = ct(ind); % Optimal c'.
                            a1(p,T-age+1,i,al) = agrid(ind); % Optimal a'.
                            alpha1(p,T-age+1,i,al) = alphagrid(ind); % Optimal alpha'.

                            end
                        end 

                    end
                    
                end

                % Print counter.
                if mod(T-age+1,5) == 0
                    fprintf('Age: %d.\n',T-age+1)
                end

            end
            
            fprintf('------------Life Cycle Problem Solved.------------\n')
            
            %% Macro variables, value, and policy functions.
            
            sol.c = c1; % Consumption policy function.
            sol.a = a1; % Saving policy function.
            sol.v = v1; % Value function.
            
        end
        
    end
end