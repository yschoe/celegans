#!/usr/bin/python
# - python3
# ported plotcelegans.m to Python
# - this will generate ../scaled-data/celegans-all-python.pdf

import numpy as np
import matplotlib.pyplot as plt

# Set data directory, relative to the location of this script
prefix="../scaled-data/"

# Load data

scaledbodya = np.genfromtxt(prefix+'scaledbodya.dat', delimiter=' ')
scaledbodyb = np.genfromtxt(prefix+'scaledbodyb.dat', delimiter=' ')
scaledbodyc = np.genfromtxt(prefix+'scaledbodyc.dat', delimiter=' ')
scaledheada = np.genfromtxt(prefix+'scaledheada.dat', delimiter=' ')
scaledheadb = np.genfromtxt(prefix+'scaledheadb.dat', delimiter=' ')
scaledtaila = np.genfromtxt(prefix+'scaledtaila.dat', delimiter=' ')
scaledtailb = np.genfromtxt(prefix+'scaledtailb.dat', delimiter=' ')

# Plot 

fig, ax = plt.subplots(1,1)
plt.rcParams['lines.linewidth']=0.1

ax.set_title("C. elegans cell location")
ax.set_aspect(1)

ax.plot(scaledbodya[:,0],scaledbodya[:,1],'*-')
ax.plot(scaledbodyb[:,0],scaledbodyb[:,1],'*-')
ax.plot(scaledbodyc[:,0],scaledbodyc[:,1],'*-')
ax.plot(scaledheada[:,0],scaledheada[:,1],'x-')
ax.plot(scaledheadb[:,0],scaledheadb[:,1],'x-')
ax.plot(scaledtaila[:,0],scaledtaila[:,1],'o-')
ax.plot(scaledtailb[:,0],scaledtailb[:,1],'o-')

plt.show()

# Save plot
fig.savefig(prefix+'celegans-all-python.pdf')
