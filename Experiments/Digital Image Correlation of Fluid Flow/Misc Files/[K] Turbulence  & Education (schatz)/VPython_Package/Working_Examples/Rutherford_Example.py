from __future__ import division  ## treat integers as real numbers in division
from visual import *
from visual.graph import *
scene.width=524
scene.height = 524
scene.x=1
scene.y=1

## constants and data
b = 1e-15 ## Impact parameter -- change this to get different scattering angles
m_alpha = 4*1.67e-27  ## Change this to the mass of the alpha particle in kg
m_gold = 197*1.67e-27  ## Change this to the mass of the gold nucleus in kg 
deltat = 1e-23  ## Change this to the value suggested in the handout
t = 0       ## start counting time at zero

qa=2*1.6e-19
qg=79*1.6e-19
oofpez=9e9

# You may need to add more constants to this section; see instructions.


## objects
## In the line below, change the initial position of the alpha particle.
## Think about how to take into account the impact parameter.
alpha = sphere(pos=(-2e-13,b,0), radius=2e-15, color=color.cyan)
gold = sphere(pos=(0,0,0), radius=8e-15, color=color.yellow) 
alpha.trail=curve(color=alpha.color)
gold.trail=curve(color=gold.color)

#gdisplay(width=500, height=250, x=524, y=1) ## Create x-momentum graphs below this line
alpha_px_graph = gcurve(color=color.cyan)
gold_px_graph = gcurve(color=color.yellow)
px_total_graph = gcurve(color=color.red)

#gdisplay(width=500, height=250, x=524, y=250) ## Create y-momentum graphs below this line
alpha_py_graph = gcurve(color=color.cyan)
gold_py_graph = gcurve(color=color.yellow)
py_total_graph = gcurve(color=color.red)

#gdisplay(width=500, height=250, x=524, y=500) ## Create energy graphs below this line
K_alpha_graph=gcurve(color=color.cyan)
K_gold_graph=gcurve(color=color.yellow)
Ugraph=gcurve(color=color.green)
KplusUgraph=gcurve(color=color.red)



## initial values
alpha.p = vector(1.46e-19,0,0) ## Change this to the initial momentum of the alpha particle
gold.p = vector(0,0,0)

ri=9e9*qa*qg*2*m_alpha/mag2(alpha.p)
print(ri)

## improve the display
scene.autoscale = 0     ## don't let camera zoom in and out as alpha moves


## calculation loop

while t < 2e-20:  ## Change the final value of t so that the alpha particle ends up far from the gold nucleus
    rate(500)
    ## calculate force on alpha particle by gold nucleus
    r=alpha.pos-gold.pos
    rmag=mag(r)
    rhat=r/rmag
    famag=oofpez*qa*qg/rmag**2
    fa=famag*rhat
    ## calculate force on gold nucleus by alpha particle
    fg=-fa
    ## update the momentum of both alpha particle and gold nucleus
    alpha.p=alpha.p+fa*deltat
    gold.p=gold.p+fg*deltat
    ## update position of both alpha particle and gold nucleus
    alpha.pos=alpha.pos+alpha.p/m_alpha*deltat
    gold.pos=gold.pos+gold.p/m_gold*deltat
    ## update trails
    alpha.trail.append(pos=alpha.pos)
    gold.trail.append(pos=gold.pos)
    ## update time   
    t=t+deltat
    ## Graph these quantities vs. time:
    ## p_x and p_y for each particle, total p_x and p_y, K_total, U_electric, and K+U
    alpha_px_graph.plot(pos=(t,alpha.p.x))
    alpha_py_graph.plot(pos=(t,alpha.p.y))
    gold_px_graph.plot(pos=(t,gold.p.x))
    gold_py_graph.plot(pos=(t,gold.p.y))
    px_total_graph.plot(pos=(t,alpha.p.x+gold.p.x))
    py_total_graph.plot(pos=(t,alpha.p.y+gold.p.y))
    K_alpha=mag(alpha.p)**2/(2*m_alpha)
    K_gold=mag(gold.p)**2/(2*m_gold)
    U=oofpez*qa*qg/rmag
    K_alpha_graph.plot(pos=(t,K_alpha))
    K_gold_graph.plot(pos=(t,K_gold))
    Ugraph.plot(pos=(t,U))
    KplusUgraph.plot(pos=(t,K_alpha+K_gold+U))

## OUTSIDE THE LOOP, calculate and print the following:
## The impact parameter b
## The x and y components of the alpha particle's momentum
## The x and y components on the gold nucleus's momenentum
## The "scattering angle" of the alpha particle
print("b=",b)
print("p_al_x=",alpha.p.x, " p_al_y=",alpha.p.y)
print("p_g_x=",gold.p.x, " p_g_y=",gold.p.y)
print("angle=",atan2(alpha.p.y,alpha.p.x)*180/pi)
