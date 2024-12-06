#!/bin/bash
#PBS -P y99
#PBS -q express
#PBS -l walltime=0:10:00
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l storage=gdata/hh5+gdata/y99+scratch/y99+gdata/vk83
#PBS -l wd
#PBS -j oe
#PBS -l software=matlab_unsw

module load matlab
module load matlab_licence

scratchdir=/scratch/y99/dkh157/mom/archive/age_g2
cd ${scratchdir}/anderson

matlab -nosplash -nojvm -singleCompThread < age_run.m >> $PBS_JOBID.log

cd ${scratchdir}/age_output
for x in `ls ocean_age.res_*.nc` ; do
    y=${x:14:4}
    ./compress_backup.py $x age_comp_${y}.nc
    if [ -f age_comp_${y}.nc ]; then
        rm $x
    fi
done
