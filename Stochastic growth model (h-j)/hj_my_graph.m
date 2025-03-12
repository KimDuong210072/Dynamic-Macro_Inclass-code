%% File Info.

%{

    my_graph.m
    ----------
    This code plots the value and policy functions.

%}

%% Graph class.

classdef hj_my_graph
    methods(Static)
        %% Plot value and policy functions.
        
        function [] = plot_policy(par,sol,figout)
            %% Plot asset policy function.

            time = linspace(1,par.T,par.T);
            
            figure(1)
            
            plot(time,sol.a)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$a_{t+1}$'},'Interpreter','latex') 
            title('Asset Policy Function')
            
            fig1name = strcat(figout,'apol.fig');
            savefig(fig1name)
            
            %% Plot consumption policy function.
            
            figure(2)
            
            plot(time,sol.c)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$C_{t}$'},'Interpreter','latex') 
            title('Consumption Policy Function')
            
            fig2name = strcat(figout,'cpol.fig');
            savefig(fig2name)
            
            %% Plot value function.
            
            figure(3)
            
            plot(time,sol.u)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$U_t(a_t)$'},'Interpreter','latex') 
            title('Value Function')

            fig3name = strcat(figout,'ufun.fig');
            savefig(fig3name)
            
        end
        
    end
end