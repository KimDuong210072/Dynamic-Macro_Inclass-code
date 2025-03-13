"""

model.py
--------
This code sets up the model.

"""

#%% Imports from Python
from numpy import linspace,log
from types import SimpleNamespace

#%% Deterministic Growth Model.
class planner():
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
        print('   The model is the deterministic growth model and is solved via Value Function Iteration.')
        
        print('\n--------------------------------------------------------------------------------------------------')
        print('Household')
        print('--------------------------------------------------------------------------------------------------\n')
        print('   The household is infintely-lived.')
        print('   It derives utility from consumption.')
        print('    -> He/she can saves capital, which is used in production, for next period.')
        
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
        par.beta = 0.96 # Discount factor.
        par.sigma = 2.00 # CRRA.

        # Technology.
        par.alpha = 0.33 # Capital's share of income.
        par.delta = 0.05 # Depreciation rate of physical capital.

        # Simulation parameters.
        par.seed_sim = 2025 # Seed for simulation.
        par.T = 50 # Number of time periods.

        # Set up capital grid.
        par.kss = (par.alpha/((1.0/par.beta)-1+par.delta))**(1.0/(1.0-par.alpha)) # Steady state capital.
            
        par.klen = 300 # Grid size for k.
        par.kmax = 1.75*par.kss # Upper bound for k.
        par.kmin = 0.25*par.kss # Minimum k.
        
        # Update parameter values to kwarg values if you don't want the default values.
        for key,val in kwargs.items():
            setattr(par,key,val)
        
        assert par.main != None
        assert par.figout != None
        assert par.beta > 0 and par.beta < 1.00
        assert par.sigma >= 1.00
        assert par.alpha > 0 and par.alpha < 1.00
        assert par.delta >= 0 and par.delta <= 1.00
        assert par.klen > 5
        assert par.kmax > par.kmin
        
        # Set up capital grid.
        par.kgrid = linspace(par.kmin,par.kmax,par.klen); # Equally spaced, linear grid for k (and k').

        # Utility function.
        par.util = util
        
        print('beta: ',par.beta)
        print('sigma: ',par.sigma)
        print('kmin: ',par.kmin)
        print('kmax: ',par.kmax)
        print('alpha: ',par.alpha)
        print('delta: ',par.delta)

#%% CRRA Utility Function.
def util(c,sigma):

    # CRRA utility
    if sigma == 1:
        u = log(c) # Log utility.
    else:
        u = (c**(1-sigma))/(1-sigma) # CRRA utility.
    
    return u