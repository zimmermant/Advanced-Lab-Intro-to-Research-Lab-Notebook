from __future__ import division
from visual import *
## INITIAL VALUE OF B
B0 = vector(0,0.2,0)

## THIS CODE DRAWS A FLOOR AND DISPLAYS THE MAGNETIC FIELD *************
xmax = .4
dx = .1
yg = -.1
for x in arange(-xmax, xmax+dx, dx):
    curve(pos=[(x,yg,-xmax),(x,yg,xmax)], color=(.3,.3,.3))
for z in arange(-xmax, xmax+dx, dx):
    curve(pos=[(-xmax,yg,z),(xmax,yg,z)],color=(.3,.3,.3))
bscale = 1
for x in arange(-xmax, xmax+dx, 2*dx):
    for z in arange(-xmax, xmax+dx, 2*dx):
        arrow(pos=(x,yg,z), axis=B0*bscale, color=(0,.8,.8))
## YOUR PROGRAM BEGINS HERE ##*******************************************
deltat = 1e-11
t = 0

particle=sphere(pos=vector(0,0.15,0), radius=0.05, color=color.red)
velocity=vector(-2e6,0.25e6,0)
trail=curve(color=particle.color)
q=-1.6e-19
m=1.6e-27
particle.p=m*velocity

while t<5*3.34e-7:
    ## Insert the necessary steps inside the loop below to update the particle's position and velocity
    ## a) Add code to calculate the needed quantities to update the particle's velocity
    F = q*cross(velocity,B0)
    particle.p = particle.p + F*deltat
    ## b) Add code to update the particle's velocity
    velocity = particle.p/m
    ## c) Update the position of the proton (movies in a straight line initially).
    particle.pos=particle.pos+velocity*deltat
    trail.append(particle.pos)
    t=t+deltat
