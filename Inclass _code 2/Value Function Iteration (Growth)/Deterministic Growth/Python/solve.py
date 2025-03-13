"""

solve.py
--------
This code solves the model.

"""

#%% Imports from Python
from numpy import argmax,inf,zeros,seterr
from numpy.linalg import norm
from types import SimpleNamespace
import time
seterr(divide='ignore')
seterr(invalid='ignore')

#%% Solve the model using VFI.
def plan_allocations(myClass):
    '''
    
    This function solves the deterministic growth model.
    
    Input:
        myClass : Model class with parameters, grids, and utility function.
        
    '''

    print('\n--------------------------------------------------------------------------------------------------')
    print('Solving the Model by Value Function Iteration')
    print('--------------------------------------------------------------------------------------------------\n')
    
    # Namespace for optimal policy funtions.
    setattr(myClass,'sol',SimpleNamespace())
    sol = myClass.sol

    # Model parameters, grids and functions.
    
    par = myClass.par # Parameters.

    beta = par.beta # Discount factor.
    sigma = par.sigma # CRRA.

    alpha = par.alpha # Capital's share of income.
    delta = par.delta # Depreciation rate

    klen = par.klen # Grid size for k.
    kgrid = par.kgrid # Grid for k (state and choice).

    util = par.util # Utility function.

    # Value Function Iteration.
    y0 = kgrid**alpha # Assume you have the steady-state capital.
    i0 = delta*kgrid # In steady state, k=k'=k*.
    c0 = y0-i0 # Steady-state consumption.
    c0[c0<0.0] = 0.0 
    v0 = util(c0,sigma)/(1-beta) # Guess of value function for each value of k.
    v0[c0<=0.0] = -inf # Set the value function to negative infinity number when c <= 0.

    crit = 1e-6;
    maxiter = 10000;
    diff = 1;
    iter = 0;

    t0 = time.time()

    while (diff > crit) and (iter < maxiter): # Iterate on the Bellman Equation until convergence.

        v1 = zeros(klen) # Container for V.
        k1 = zeros(klen) # Container for k'.

        for p in range(0,klen): # Loop over the k-states.

            # Macro variables.
            y = kgrid[p]**alpha # Output given k, kgrid(p).
            i = kgrid-((1-delta)*kgrid[p]) # Possible values for investment, i=k'-(1-delta)k, when choosing k' from kgrid and given k.
            c = y-i # Possible values for consumption, c = y-i, given y and i.
            c[c<0.0] = 0.0

            # Solve the maximization problem.
            vall = util(c,sigma) + beta*v0 # Compute the value function for each choice of k', given k.
            vall[c<=0.0] = -inf # Set the value function to negative infinity number when c <= 0.
            v1[p] = max(vall) # Maximize: vmax is the maximized value function; ind is where it is in the grid.
            k1[p] = kgrid[argmax(vall)] # Optimal k'.

        diff = norm(v1-v0) # Check convergence.
        v0 = v1; # Update guess.

        iter = iter + 1; # Update counter.
        
        # Print counter.
        if iter%25 == 0:
            print('Iteration: ',iter,'.\n')

    t1 = time.time()
    print('Elapsed time is ',t1-t0,' seconds.')
    print('Converged in ',iter,' iterations.')

    # Macro variables, value, and policy functions.
    sol.y = kgrid**alpha # Output.
    sol.k = k1 # Capital policy function.
    sol.i = k1-((1-delta)*kgrid) # Investment policy function.
    sol.c = sol.y-sol.i # Consumption policy function.
    sol.c[sol.c<0.0] = 0.0
    sol.v = v1 # Value function.
    sol.v[sol.c<=0.0] = -inf