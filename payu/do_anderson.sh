#!/bin/bash
#PBS -P y99
#PBS -q express
#PBS -l walltime=0:20:00
#PBS -l ncpus=1
#PBS -l mem=24GB
#PBS -l storage=gdata/hh5+gdata/y99+scratch/y99+gdata/vk83
#PBS -l wd
#PBS -j oe
#PBS -l software=matlab_unsw

module load matlab
module load matlab_licence

# BENOIT: Check archive directory.
# IF model has not completed 10 years, then do nothing.
# IF model has completed 10 years, submit matlab job.

scratchdir=/scratch/y99/dkh157/access-om2/archive/caco3dyn2_aa
cd ${scratchdir}/anderson

matlab -nosplash -nojvm -singleCompThread < wombat_run.m >> $PBS_JOBID.log

module load conda/analysis3
cd ${scratchdir}/aa_output
nccompress -o *nc
