"""

run_vfi_cake.py
---------------
This code solves the deterministic cake-eating problem using value function iteration.

"""

#%% Import from Python and set project directory
import os
os.chdir("C:\\Users\\xmgb\\Dropbox\\02_FUV\\teaching\\spring_2025\\dynamic_macro\\code\\vfi_cake_python")
main = os.getcwd()
figout = main+"\\output\\figures"

#%% Import from folder
from model import person
from solve import cake_decisions
from simulate import eat_cake
from my_graph import log_meals

#%% Cake-eating model.
hungry_person = person()

# Set the parameters, state space, and utility function.
hungry_person.setup(main=main,figout=figout,beta = 0.95,sigma=1.00) # You can set the parameters here or use the defaults.

# Solve the model.
cake_decisions(hungry_person) # Obtain the policy functions for cake size.

# Simulate the model.
eat_cake(hungry_person) # Simulate forward in time.

# Graphs.
log_meals(hungry_person) # Plot policy functions and simulations.
