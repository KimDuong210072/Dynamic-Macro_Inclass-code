"""

model.py
--------
This code sets up the model.

"""

#%% Imports from Python
from numpy import linspace,log
from types import SimpleNamespace

#%% Cake-Eating Model.
class person():
    '''
    
    Methods:
        __init__(self,**kwargs) -> Set the household's attributes.
        setup(self,**kwargs) -> Sets parameters.
        
    '''
    
    #%% Constructor.
    def __init__(self,**kwargs):
        '''        
        
        This initializes the model.
        
        Optional kwargs:
            All parameters changed by setting kwarg.
            
        '''

        print('--------------------------------------------------------------------------------------------------')
        print('Model')
        print('--------------------------------------------------------------------------------------------------\n')
        print('   The model is the deterministic cake-eating model and is solved via Value Function Iteration.')
        
        print('\n--------------------------------------------------------------------------------------------------')
        print('Person')
        print('--------------------------------------------------------------------------------------------------\n')
        print('   The person is infintely-lived.')
        print('   It derives utility from eating cake.')
        print('    -> He/she can save some cake for next period.')
        
    #%% Set up model.
    def setup(self,**kwargs):
        '''
        
        This sets the parameters and creates the grids for the model.
        
            Input:
                self : Model class.
                kwargs : Values for parameters if not using the default.
                
        '''
        
        # Namespace for parameters, grids, and utility function.
        setattr(self,'par',SimpleNamespace())
        par = self.par

        print('\n--------------------------------------------------------------------------------')
        print('Parameters:')
        print('--------------------------------------------------------------------------------\n')
        
        # Preferences.
        par.beta = 0.95 # Discount factor.
        par.sigma = 1.00 # CRRA.

        # Simulation parameters.
        par.seed_sim = 2025 # Seed for simulation.
        par.T = 50 # Number of time periods.

        # Set up cake grid.
        par.wlen = 300 # Grid size for W.
        par.wmax = 20.00 # Upper bound for W.
        par.wmin = 0.00 # Minimum W.
        
        # Update parameter values to kwarg values if you don't want the default values.
        for key,val in kwargs.items():
            setattr(par,key,val)
        
        assert par.main != None
        assert par.figout != None
        assert par.beta > 0 and par.beta < 1.00
        assert par.sigma >= 1.00
        assert par.wlen > 5
        assert par.wmax > par.wmin
        
        # Set up cake grid.
        par.wgrid = linspace(par.wmin,par.wmax,par.wlen); # Equally spaced, linear grid for W (and W').

        # Utility function.
        par.util = util
        
        print('beta: ',par.beta)
        print('sigma: ',par.sigma)
        print('wmin: ',par.wmin)
        print('wmax: ',par.wmax)
        print('wlen: ',par.wlen)

#%% CRRA Utility Function.
def util(c,sigma):

    # CRRA utility
    if sigma == 1:
        u = log(c) # Log utility.
    else:
        u = (c**(1-sigma))/(1-sigma) # CRRA utility.
    
    return u