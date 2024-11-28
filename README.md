# AndersonAcceleration
## by Samar Khatiwala
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

## Modifications by David Hutchinson 2024-Nov-29

Added the following files:
1. age_run.m : for running the algorithm.
2. g_age.m : the wrapper function that reads model output and sets a new run going

Modified the original function:
1. AndersonAcceleration.m : Small changes made to Khatiwala's function to be compatible with my setup.
