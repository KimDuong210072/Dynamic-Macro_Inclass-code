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
def grow_economy(myClass):
    '''
    
    This function simulates the deterministic growth model.
    
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

    klen = par.klen # Capital grid size.
    kgrid = par.kgrid # Capital today (state).
    
    yout = sol.y # Production function.
    kpol = sol.k # Policy function for capital.
    cpol = sol.c # Policy function for consumption.
    ipol = sol.i # Policy function for investment.

    T = par.T # Time periods.
    ysim = zeros(par.T) # Container for simulated output.
    ksim = zeros(par.T) # Container for simulated capital stock.
    csim = zeros(par.T) # Container for simulated consumption.
    isim = zeros(par.T) # Container for simulated investment.
    usim = zeros(par.T) # Container for simulated utility.
            
    # Begin simulation.
    
    seed(seed_sim)
    k0_ind = choice(linspace(0,klen,klen,endpoint=False,dtype=int),1) # Index for initial capital stock.
    ysim[0] = yout[k0_ind] # Output in period 1 given k0.
    csim[0] = cpol[k0_ind] # Consumption in period 1 given k0.
    ksim[0] = kpol[k0_ind] # Capital choice for period 2 given k0.
    isim[0] = ipol[k0_ind] # Investment in period 1 given k0.
    usim[0] = util(csim[0],sigma) # Utility in period 1 given k0.

    # Simulate endogenous variables.

    for j in range(1,T): # Time loop.
        kt_ind = where(ksim[j-1]==kgrid); # Capital choice in the previous period is the state today. Find where the latter is on the grid.
        ysim[j] = yout[kt_ind] # Output in period t.
        csim[j] = cpol[kt_ind] # Consumption in period t.
        ksim[j] = kpol[kt_ind] # Capital stock for period t+1.
        isim[j] = ipol[kt_ind] # Investment in period t.
        usim[j] = util(csim[j],sigma) # Utility in period t.

    sim.ysim = ysim # Simulated output.
    sim.ksim = ksim # Simulated capital choice.
    sim.csim = csim # Simulated consumption.
    sim.isim = isim # Simulated investment.
    sim.usim = usim # Simulated utility.