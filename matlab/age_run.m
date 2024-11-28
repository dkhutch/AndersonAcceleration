restartfile = 'restart.mat';
initfile = '/scratch/y99/dkh157/mom/archive/age_g2/restart499/ocean_age.res.nc';

if isfile(restartfile)
    load(restartfile)
else
    fprintf('start from %s\n', initfile)
    load('wet3d.mat');
    age3d = ncread(initfile, 'age_global');
    age_vec = age3d(wet3d);
    aa.x = age_vec;
end

histParams.ncheckpointfreq = -1;
[xsol,iter,aa] = AndersonAcceleration(@g_age, aa.x, [], histParams, restartfile);

