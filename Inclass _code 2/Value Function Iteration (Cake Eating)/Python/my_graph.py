"""

my_graph.py
-----------
This code plots the value and policy functions.

"""

#%% Imports from Python
from matplotlib.pyplot import close,figure,plot,xlabel,ylabel,title,savefig,show
from numpy import linspace
#%% Plot the model functions and simulations.
def log_meals(myClass):
    '''
    
    This function plots the model functions and simulations.
    
    Input:
        myClass : Model class with parameters, grids, utility function, policy functions, and simulations.
        
    '''

    # Model parameters, policy and value functions, and simulations.
    par = myClass.par # Parameters.
    sol = myClass.sol # Policy functions.
    sim = myClass.sim # Simulations.

    # Cake policy function.

    figure(1)
    plot(par.wgrid,sol.w)
    xlabel('$W_{t}$')
    ylabel('$W_{t+1}$') 
    title('Cake Size Policy Function')
    
    fig1name = myClass.par.figout+"\\wpol.png"
    print(fig1name)
    savefig(fig1name)

    # Plot consumption policy function.
    
    figure(2)
    plot(par.wgrid,sol.c)
    xlabel('$W_{t}$')
    ylabel('$C_{t}$') 
    title('Consumption Policy Function')
    
    fig2name = myClass.par.figout+"\\cpol.png"
    savefig(fig2name)

    # Plot value function.
    
    figure(3)
    plot(par.wgrid,sol.v)
    xlabel('$W_{t}$')
    ylabel('$V_t(W_t)$') 
    title('Value Function')

    fig3name = myClass.par.figout+"\\vfun.png"
    savefig(fig3name)
    
    # Plot simulated consumption.
    
    tgrid = linspace(1,par.T,par.T,dtype=int)

    figure(4)
    plot(tgrid,sim.csim)
    xlabel('Time')
    ylabel('$C^{sim}_t$') 
    title('Simulated Consumption')

    fig4name = myClass.par.figout+"\\csim.png"
    savefig(fig4name)
    
    # Plot simulated cake size.
    
    figure(5)
    plot(tgrid,sim.wsim)
    xlabel('Time')
    ylabel('$W^{sim}_t$') 
    title('Simulated Cake Size')

    fig5name = myClass.par.figout+"\\wsim.png"
    savefig(fig5name)
    
    # Plot simulated utility.
    
    figure(6)
    
    plot(tgrid,sim.usim)
    xlabel('Time')
    ylabel('$U^{sim}_t$') 
    title('Simulated Utility')

    fig6name = myClass.par.figout+"\\usim.png"
    savefig(fig6name)

    #show()
    #close('all')