from __future__ import division
from visual import *
scene.width =1024
scene.height = 760

#CONSTANTS
G = 6.7e-11
mEarth = 6e24
mcraft = 15e3
deltat = 60

#OBJECTS AND INITIAL VALUES
Earth = sphere(pos=vector(0,0,0), radius=6.4e6, color=color.cyan)
scene.range=11*Earth.radius
# Choose an exaggeratedly large radius for the
# space craft so that you can see it!
craft = sphere(pos=vector(-10*Earth.radius, 0,0), color=color.yellow)
vcraft = vector(0,0,0)
pcraft = mcraft*vcraft

trail = curve(color=craft.color)    ## craft trail: starts with no points
t = 0
scene.autoscale = 0       ## do not allow camera to zoom in or out

#CALCULATIONS

while t < 10*365*24*60*60:
    rate(200)       ## slow down motion to make animation look nicer
    ## you must add statements for the iterative update of 
    ## gravitational force, momentum, and position
    

    ## check to see if the spacecraft has crashed on the Earth.
    ## if so, get out of the calculation loop
    

    trail.append(pos=craft.pos) ## this adds the new position of the spacecraft to the trail
    t = t+deltat

print 'Calculations finished after ',t,'seconds'
