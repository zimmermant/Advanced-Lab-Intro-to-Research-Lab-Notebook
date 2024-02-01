'''
Demonstrate use of a log color scale in contourf
'''

import matplotlib.pyplot as plt
import numpy as np


N = 300  #Number of points
x = np.linspace(-3.0, 3.0, N)  #Min and max values in x-direction
y = np.linspace(-2.0, 2.0, N)  #Min and max values in y-direction

X, Y = np.meshgrid(x, y)   #Create grid that will be used for calculations

k=420   #wavenumber for pitchfork
m=1    #order of pitchfork


z = (1+np.cos(k*X-m*np.arctan(Y/X)))  # Function to generate pitchfork

level_resolution=200  #Number of contours on contourf plot (increase for finer resolution)
levels = np.linspace(0, 2, level_resolution)  #Used to set contours from 0 to 2

my_dpi=192  #Set dots per inch of display (dpi)
plt.figure(figsize=(640/my_dpi, 480/my_dpi), dpi=my_dpi) 
# Plot a filled contour plot (contourf) and set color-map to 'gray'
cs = plt.contourf(X, Y, z,levels=levels,cmap='gray')  #Create contour plot

plt.axis('off')  #Turns off axes around image.  
plt.show()   #Show figure
