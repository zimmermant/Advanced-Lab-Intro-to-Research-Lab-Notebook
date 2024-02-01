from __future__ import division
from visual import *

## Constants

# In this section, define any constants you may need


## Objects

#Change the initial vector position of the proton below:
proton = sphere(pos=vector(0,0,0), radius=1e-11, color=color.red)

#Change the observation location (position of the tail of the arrow) below:
barrow1=arrow(pos=vector(0,0,0), axis=vector(0,0,0), color=color.cyan)

#Add more arrows to find magnetic field at other observation locations.
#Set axis to (0,0,0) initially and update it in the loop.


## Initial values

velocity = ??? # Enter the proton's velocity
deltat = 1e-19 # Adjust if program runs too slowly or too quickly

scene.autoscale=0 #Turns off autoscaling.  Set to 1 to turn it back on.


## Loop

while proton.x<5e-10:

    # For each magnetic field vector:
    # 1. Calculate r and rhat
    # 2. Calculate the magnetic field vector
    # 3. Calculate the new axis of the arrow.  Scale it appropriately.


    # Update the proton's position
