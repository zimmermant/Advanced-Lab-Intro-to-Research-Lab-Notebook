from __future__ import division  ## treat integers as real numbers in division
from visual import *
from visual.graph import *
scene.width=524
scene.height=524
scene.x=1
scene.y=1

## constants and data
b = 0 ## Impact parameter -- change this to get different scattering angles
m_alpha = 1  ## Change this to the mass of the alpha particle in kg
m_gold = 1  ## Change this to the mass of the gold nucleus in kg 
deltat = 1  ## Change this to the value suggested in the handout
t = 0       ## start counting time at zero

# You may need to add more constants to this section; see instructions.


## objects
## In the line below, change the initial position of the alpha particle.
## Think about how to take into account the impact parameter.
alpha = sphere(pos=(0,0,0), radius=2e-15, color=color.cyan)
gold = sphere(pos=(0,0,0), radius=8e-15, color=color.yellow) 
alpha.trail=curve(color=alpha.color)
gold.trail=curve(color=gold.color)

gdisplay(width=500, height=250, x=524, y=1) ## Create x-momentum graphs below this line

gdisplay(width=500, height=250, x=524, y=250) ## Create y-momentum graphs below this line

gdisplay(width=500, height=250, x=524, y=500) ## Create energy graphs below this line


## initial values
alpha.p = vector(0,0,0) ## Change this to the initial momentum of the alpha particle
gold.p = vector(0,0,0)

## improve the display
scene.autoscale = 0     ## don't let camera zoom in and out as alpha moves


## calculation loop

while t < 1:  ## Change the final value of t so that the alpha particle ends up far from the gold nucleus
    
    ## calculate force on alpha particle by gold nucleus
    
    ## calculate force on gold nucleus by alpha particle
       
    ## update the momentum of both alpha particle and gold nucleus

    ## update position of both alpha particle and gold nucleus

    ## update trails

    ## update time   
    
    ## Graph these quantities vs. time:
    ## p_x and p_y for each particle, total p_x and p_y, K_alpha, K_gold, U_electric, and K+U

## OUTSIDE THE LOOP, calculate and print the following:
## The impact parameter b
## The x and y components of the alpha particle's momentum
## The x and y components on the gold nucleus's momenentum
## The "scattering angle" of the alpha particle
