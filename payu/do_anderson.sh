#!/bin/bash
#PBS -P y99
#PBS -q express
#PBS -l walltime=0:10:00
#PBS -l ncpus=1
#PBS -l mem=12GB
#PBS -l storage=gdata/xp65+gdata/y99+scratch/y99+gdata/vk83
#PBS -l wd
#PBS -j oe
#PBS -l software=matlab_unsw

module load matlab/R2023b
module load matlab_licence
module load payu/1.1.7

# BENOIT: Check archive directory.
# IF model has not completed 10 years, then do nothing.
# IF model has completed 10 years, submit matlab job.

scratchdir=/scratch/y99/dkh157/mom/archive/a15_c3_bl_aa
cd ${scratchdir}/AndersonAcceleration

matlab -nosplash -nojvm -singleCompThread < bling_run.m >> $PBS_JOBID.log

cd ${scratchdir}/aa_output
nccompress -o *nc

# cd ${scratchdir}/age_output
# for x in `ls ocean_age.res_*.nc` ; do
#     y=${x:14:4}
#     ./compress_backup.py $x age_comp_${y}.nc
#     if [ -f age_comp_${y}.nc ]; then
#         rm $x
#     fi
# done
