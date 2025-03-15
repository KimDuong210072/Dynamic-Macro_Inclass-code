%% File Info.

%{

    djmy_graph.m
    ----------
    This code plots the value and policy functions and the time path of the variables.

%}

%% Graph class.

classdef djmy_graph
    methods(Static)
        %% Plot value and policy functions.
        
        function [] = plot_policy(par,sol,sim)
            %% Plot consumption policy function.

            ystate = par.ygrid;
            age = linspace(1,par.T,par.T,par.T);
            alpha_slice = 1; 

            figure(1)
            % Lowest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.c(1, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$c_{t}$','Interpreter','latex')
            title('Consumption Policy Function, Lowest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            figure(2)
            % Highest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.c(end, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$c_{t}$','Interpreter','latex')
            title('Consumption Policy Function, Highest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            %% Plot saving policy function.
            
            figure(3)
            % Lowest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.a(1, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$a_{t+1}$','Interpreter','latex')
            title('Saving Policy Function, Lowest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            figure(4)
            % Highest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.a(end, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$a_{t+1}$','Interpreter','latex')
            title('Saving Policy Function, Highest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            %% Plot value function.
            
            figure(5)
            % Lowest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.v(1, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$v_t(a_t,t)$','Interpreter','latex')
            title('Value Function, Lowest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            figure(6)
            % Highest asset level, optimal α slice:
            surf(age(1:5:end), ystate, squeeze(sol.v(end, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$v_t(a_t,t)$','Interpreter','latex')
            title('Value Function, Highest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            %% Plot Alpha (Portfolio Share) Policy Function
            
            figure(7)
            % Lowest asset level:
            surf(age(1:5:end), ystate, squeeze(sol.alpha(1, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$\alpha_t$','Interpreter','latex')
            title('Alpha Policy Function, Lowest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            figure(8)
            % Highest asset level:
            surf(age(1:5:end), ystate, squeeze(sol.alpha(end, 1:5:end, :, alpha_slice))')
            xlabel('t','Interpreter','latex')
            ylabel('$y_{t}$','Interpreter','latex')
            zlabel('$\alpha_t$','Interpreter','latex')
            title('Alpha Policy Function, Highest $a_t$, optimal $\alpha$','Interpreter','latex')
            
            %% Plot consumption policy function.

            lcp_c = nan(par.T,1);
            lcp_a = nan(par.T,1);
            lcp_u = nan(par.T,1);

            for i=1:par.T
                lcp_c(i) = mean(sim.csim(sim.tsim==i),"omitnan");
                lcp_a(i) = mean(sim.asim(sim.tsim==i),"omitnan");
                lcp_u(i) = mean(sim.usim(sim.tsim==i),"omitnan");
            end

            figure(7)
            
            plot(age,lcp_c)
                xlabel({'$Age$'},'Interpreter','latex')
                ylabel({'$c^{sim}_{t}$'},'Interpreter','latex') 
            title('LCP of Consumption')
            
            %% Plot saving policy function.
            
            figure(8)
            
            plot(age,lcp_a)
                xlabel({'$Age$'},'Interpreter','latex')
                ylabel({'$a^{sim}_{t+1}$'},'Interpreter','latex') 
            title('LCP of Savings')
            
            %% Plot value function.
            
            figure(9)
            
            plot(age,lcp_u)
                xlabel({'$Age$'},'Interpreter','latex')
                ylabel({'$u^{sim}_t$'},'Interpreter','latex') 
            title('LCP of Utility')

        end
        
    end
end