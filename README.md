# AndersonAcceleration
## by Samar Khatiwala with modifications by David Hutchinson
Anderson Acceleration for solving fixed point problems and spin-up of seasonally forced ocean biogeochemical models

Note: I'm not currently updating this repository while I restructure the code. Email me for the latest version as well as a python implementation.

This repository contains code for solving fixed point problems using Anderson Acceleration. While it can be used for 
any fixed point problem it was designed to enable use of the code on batch HPC systems for computing equilibrium solutions 
of periodically-forced ocean models. It is based on the MATLAB routine AndAcc.m originally written by Homer F. Walker 
(Anderson acceleration: Algorithms and implementations, Worcester Polytechnic Institute Mathematical Sciences Department 
Research Report MS-6-15-50, 10/14/2011) with extensive modifications as per Khatiwala (2022), "Fast spin-up of geochemical 
tracers in ocean circulation and climate models, J. Adv. Model. Earth Sys., https://doi.org/10.1029/2022MS003447.

Cite as:

Khatiwala, S. (2022). Fast spin-up of geochemical tracers in ocean circulation and climate models, 
J. Adv. Model. Earth Sys., https://doi.org/10.1029/2022MS003447.

License:

See LICENSE.txt for licensing information.

## Modifications by David Hutchinson 2026-Apr-23

### In the top folder
Added the following files:
1. bling_run.m : for running the algorithm.
2. g_bling.m : the wrapper function that reads model output and sets a new run going

Modified the original function:
1. AndersonAcceleration.m : Small changes made to Khatiwala's function to be compatible with my setup.

### In the payu folder:
1. do_anderson.sh : script that runs the matlab code after completing one cycle of simulation
2. config.yaml : my config file that specifies `do_anderson.sh' as a postscript

### NOTE:

In this example, I initiate the run from restart009. I then extract BGC output from restart010 and feed into the algorithm. Once complete, I save the new tracers, then delete the folders output010 and restart010. Watch out for updates to directory names and restart numbers!!
