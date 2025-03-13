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
def cake_decisions(myClass):
    '''
    
    This function solves the cake-eating problem.
    
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

    wlen = par.wlen # Grid size for W.
    wgrid = par.wgrid # Grid for W (state and choice).

    util = par.util # Utility function.

    # Value Function Iteration.
    v0 = util(wgrid,sigma)/(1-beta) # Guess of value function.

    crit = 1e-6;
    maxiter = 10000;
    diff = 1;
    iter = 0;

    t0 = time.time()

    while (diff > crit) and (iter < maxiter): # Iterate on the Bellman Equation until convergence.
        
        v1 = zeros(wlen) # Container for V.
        w1 = zeros(wlen) # Container for W'.
        
        for i in range(0,wlen): # Loop over the state space and maximize.
            c = wgrid[i]-wgrid # Consumption, c = W-W', for a given state of W, wgrid(i), and the vector of choices for W', wgrid.
            c[c<0.0] = 0.0
            vall = util(c,sigma) + beta*v0 # Compute the Bellman equation for each choice of W', given a particular state of W.
            vall[c<=0] = -inf # Set the value function to negative infinity when c <= 0.
            v1[i] = max(vall) # Find the value of the maximized Bellman equation. Note that wgrid(i)-wgrid is W-W', where W' is a vector.
            w1[i] = wgrid[argmax(vall)] # Find the value of W' that maximizes the Bellman equation.
        
        diff = norm(v1-v0) # Check convergence.
        v0 = v1; # Update guess.
        
        iter = iter + 1; # Update counter.
        
        # Print counter.
        if iter%25 == 0:
            print('Iteration: ',iter,'.\n')

    t1 = time.time()
    print('Elapsed time is ',t1-t0,' seconds.')
    print('Converged in ',iter,' iterations.')

    c = wgrid-w1
    c[c<0.0] = 0.0

    # Value and policy functions.
    sol.c = c # Consumption policy function.
    sol.w = w1 # Cake size policy function.
    sol.v = v1 # Value function.
    