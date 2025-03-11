%% File Info.

%{

    my_graph.m
    ----------
    This code plots the value and policy functions.

%}

%% Graph class.

classdef my_graph
    methods(Static)
        %% Plot value and policy functions.
        
        function [] = plot_policy(par,sol,sim,figout)
            %% Plot asset policy function.
            
            figure(1)
            
            plot(par.agrid,sol.a)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$a_{t+1}$'},'Interpreter','latex') 
            title('Asset Policy Function')
            
            fig1name = strcat(figout,'apol.fig');
            savefig(fig1name)
            
            %% Plot consumption policy function.
            
            figure(2)
            
            plot(par.agrid,sol.c)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$C_{t}$'},'Interpreter','latex') 
            title('Consumption Policy Function')
            
            fig2name = strcat(figout,'cpol.fig');
            savefig(fig2name)
            
            %% Plot value function.
            
            figure(3)
            
            plot(par.agrid,sol.u)
                xlabel({'$a_{t}$'},'Interpreter','latex')
                ylabel({'$U_t(a_t)$'},'Interpreter','latex') 
            title('Value Function')

            fig3name = strcat(figout,'ufun.fig');
            savefig(fig3name)
            
            %% Plot simulated consumption.
            
            tgrid = linspace(1,par.T,par.T);

            figure(4)
            
            plot(tgrid,sim.csim)
                xlabel({'Time'},'Interpreter','latex')
                ylabel({'$C^{sim}_t$'},'Interpreter','latex') 
            title('Simulated Consumption')

            fig4name = strcat(figout,'csim.fig');
            savefig(fig4name)
            
            %% Plot simulated asset.
            
            figure(5)
            
            plot(tgrid,sim.asim)
                xlabel({'Time'},'Interpreter','latex')
                ylabel({'$a^{sim}_t$'},'Interpreter','latex') 
            title('Simulated Asset')

            fig5name = strcat(figout,'asim.fig');
            savefig(fig5name)
            
            %% Plot simulated utility.
            
            figure(6)
            
            plot(tgrid,sim.usim)
                xlabel({'Time'},'Interpreter','latex')
                ylabel({'$U^{sim}_t$'},'Interpreter','latex') 
            title('Simulated Utility')

            fig6name = strcat(figout,'usim.fig');
            savefig(fig6name)
            
        end
        
    end
end