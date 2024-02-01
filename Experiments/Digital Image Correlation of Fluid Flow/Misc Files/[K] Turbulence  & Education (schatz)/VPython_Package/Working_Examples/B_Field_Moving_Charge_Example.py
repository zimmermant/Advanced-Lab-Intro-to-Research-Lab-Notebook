from __future__ import division
from visual import *

## Constants
magconstant=4*pi*1e-7
q=1.6e-19
scalefactor = 1e-9

# In this section, define any constants you may need


## Objects

#Change the initial vector position of the proton below:
proton = sphere(pos=vector(-4e-10,0,0), radius=1e-11, color=color.red)

#Change the observation location (position of the tail of the arrow) below:
barrow1=arrow(pos=vector(0,8e-11,0), axis=vector(0,0,0), color=color.cyan)

#Add more arrows to find magnetic field at other observation locations.
#Set axis to (0,0,0) initially and update it in the loop.
barrow2=arrow(pos=vector(0,-8e-11,0), axis=vector(0,0,0), color=color.cyan)
barrow3=arrow(pos=vector(0,0,8e-11), axis=vector(0,0,0), color=color.cyan)
barrow4=arrow(pos=vector(0,0,-8e-11), axis=vector(0,0,0), color=color.cyan)


## Initial values

velocity = vector(4e4,0,0) # Enter the proton's velocity
deltat = 1e-19 # Adjust if program runs too slowly or too quickly

scene.autoscale=0 #Turns off autoscaling.  Set to 1 to turn it back on.


## Loop

while proton.x<5e-10:

    # For each magnetic field vector:
    # 1. Calculate r and rhat
    r1=barrow1.pos-proton.pos
    r1mag=mag(r1)
    r1hat=r1/r1mag

    r2=barrow2.pos-proton.pos
    r3=barrow3.pos-proton.pos
    r4=barrow4.pos-proton.pos
    
    # 2. Calculate the magnetic field vector
    B1=magconstant*q*cross(velocity,r1hat)/r1mag**2
    B2=magconstant*q*cross(velocity,r2)/mag(r2)**3
    B3=magconstant*q*cross(velocity,r3)/mag(r3)**3
    B4=magconstant*q*cross(velocity,r4)/mag(r4)**3
    
    # 3. Calculate the new axis of the arrow.  Scale it appropriately.
    barrow1.axis=scalefactor*B1
    barrow2.axis=scalefactor*B2
    barrow3.axis=scalefactor*B3
    barrow4.axis=scalefactor*B4

    # Update the proton's position
    proton.pos = proton.pos + velocity*deltat

print(B1)
