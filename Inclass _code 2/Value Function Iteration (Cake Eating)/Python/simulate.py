"""

simulate.py
-----------
This code simulates the model.

"""

#%% Imports from Python
from numpy import linspace,where,zeros
from numpy.random import choice, seed
from types import SimpleNamespace

#%% Simulate the model.
def eat_cake(myClass):
    '''
    
    This function simulates the cake-eating problem.
    
    Input:
        myClass : Model class with parameters, grids, utility function, and policy functions.
        
    '''

    print('\n--------------------------------------------------------------------------------------------------')
    print('Simulate the Model')
    print('--------------------------------------------------------------------------------------------------\n')
    
    # Namespace for simulation.
    setattr(myClass,'sim',SimpleNamespace())
    sim = myClass.sim

    # Model parameters, grids and functions.
    
    par = myClass.par # Parameters.
    sol = myClass.sol # Policy functions.

    sigma = par.sigma # CRRA.
    util = par.util # Utility function.
    seed_sim = par.seed_sim # Seed for simulation.

    wlen = par.wlen # Cake size grid size.
    wgrid = par.wgrid # Cake size state variable.

    wpol = sol.w # Cake size policy function.
    cpol = sol.c # Consumption policy function.

    T = par.T # Time periods.
    csim = zeros(T) # Container for simulated consumption.
    wsim = zeros(T) # Container for simulated cake size.
    usim = zeros(T) # Container for simulated value function.
    
    # Begin simulation.
    
    seed(seed_sim)

    w0_ind = choice(linspace(0,wlen,wlen,endpoint=False,dtype=int),1) # Initial cake size index.
    csim[0] = cpol[w0_ind] # Period 1 consumption.
    wsim[0] = wpol[w0_ind] # Period 1 cake size.
    usim[0] = util(csim[0],sigma) # Period 1 value function.

    # Simulate endogenous variables.

    for j in range(1,T): # Time loop.
        w_ind = where(wsim[j-1]==wgrid) # Find where cake size policy is on the cake size state grid.
        csim[j] = cpol[w_ind] # Period t consumption.
        wsim[j] = wpol[w_ind] # Period t cake size.
        usim[j] = util(csim[j],sigma) # Period t value function.

    sim.csim = csim # Simulate consumption.
    sim.wsim = wsim # Simulated cake size.
    sim.usim = usim # Simulated utility function.