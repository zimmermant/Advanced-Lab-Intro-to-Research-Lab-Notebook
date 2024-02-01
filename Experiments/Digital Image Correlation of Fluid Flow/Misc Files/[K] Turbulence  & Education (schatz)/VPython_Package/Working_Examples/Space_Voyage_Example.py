from __future__ import division
from visual import *

######################################
#Uncomment these lines to "follow" the spacecraft"

#scene.width =1024
#scene.height = 760
######################################

######################################


#scene.fullscreen=1  ###Make it full screen


#CONSTANTS
G = 6.7e-11
mEarth = 6e24
mMoon = 7e22
mcraft = 15e3
deltat = 10

#OBJECTS AND INITIAL VALUES
Earth = sphere(pos=vector(0,0,0), radius=6.4e6, color=color.cyan)
Moon = sphere(pos=vector(4e8,0,0), radius=1.75e6, color=color.white)

# Choose an exaggeratedly large radius for the
# space craft so that you can see it!
craft = sphere(pos=vector(-10*Earth.radius, 0*Earth.radius,0), radius=1e6,color=color.yellow)
# (0,3.2735e3,0) or (0,3.27e3,0) are interesting initial velocities
vcraft = vector(0,3.2735e3,0)
pcraft = mcraft*vcraft
parr = arrow(color=color.green)
Fnet_tangent_arrow=arrow(color=color.red)
Fnet_perp_arrow=arrow(color=color.blue)

#pscale=(mag(Moon.pos-Earth.pos))/10/mag(pcraft)
pscale=1
fscale=1e5

trail = curve(color=craft.color)    ## craft trail: starts with no points
t = 0

#CALCULATIONS

while t < 60*365*24*60*60:
    
    ## Add these lines to follow the sphere
    scene.center=craft.pos
    scene.range=craft.radius*60
    #########################################
    rate(5000)
    ## grab the momentum mag before update
    p_init = mag(pcraft)

    ## you must add statements for the iterative update of 
    ## gravitational force, momentum, and position
    rE = craft.pos - Earth.pos
    FgravE = -G*mEarth*mcraft*rE/mag(rE)**3

    rM = craft.pos - Moon.pos
    FgravM = -G*mMoon*mcraft*rM/mag(rM)**3

    Fnet = FgravM + FgravE

    pcraft = pcraft + Fnet*deltat
    p_final = mag(pcraft)
    craft.pos = craft.pos + pcraft/mcraft*deltat

    parr.pos = craft.pos
    parr.axis = pscale*pcraft

    Fnet_tangent = (p_final - p_init)/deltat*pcraft/mag(pcraft)*pscale
    Fnet_perp = Fnet - Fnet_tangent

    Fnet_tangent_arrow.pos = craft.pos
    Fnet_tangent_arrow.axis = fscale*Fnet_tangent
    Fnet_perp_arrow.pos = craft.pos
    Fnet_perp_arrow.axis = fscale*Fnet_perp


    ## check to see if the spacecraft has crashed on the Earth.
    ## if so, get out of the calculation loop
    if mag(rE) < Earth.radius:
        break
    
    if mag(rM) < Moon.radius:
        break

    trail.append(pos=craft.pos) ## this adds the new position of the spacecraft to the trail
    t = t+deltat

print('Calculations finished after ',t,'seconds')
