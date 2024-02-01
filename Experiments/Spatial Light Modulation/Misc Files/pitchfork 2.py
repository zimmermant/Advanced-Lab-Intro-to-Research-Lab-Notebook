import pygame
import sys
import numpy as np
import matplotlib.pyplot as plt
from math import cos, atan,pi

pygame.init()
screen = pygame.display.set_mode((640,480))

x_max=640
y_max=480
k=50
m=1
for x in range(x_max):
    for y in range(y_max):
        if x==x_max/2:
            G=1+cos(m*pi/2)
        else:
            G=1+cos(k*(x-x_max/2)-m*atan((y-y_max/2)/(x-x_max/2)))
        color=((G/2*255),(G/2*255),(G/2*255))
        screen.fill(color, ((x,y), (1, 1)))
pygame.display.update()

pos=[]
G_mag=[]
y=100
x_rng=35
for x in range(x_rng):
    if x==0:
        G=1+cos(m*pi/2)
    else:
        G=1+cos(k*(x)-m*atan((y)/(x)))
    pos.append(x)
    G_mag.append(G)
plt.plot(pos,G_mag)
plt.show()
print atan(100/25)
print atan(100/30)
print atan(100/35)
print atan(100/40)
print atan(100/50)
print atan(100/60)
print atan(100/70)



while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit(); sys.exit();