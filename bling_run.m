restartfile = 'aa_restart.mat';
initfile = '/scratch/y99/dkh157/mom/archive/a15_c3_bl_aa/restart009/ocean_bling.res.nc';

bgc_tracers = {...
    'do14c', ...     
    'di14c', ...     
    'dic', ...     
    'alk', ...     
    'po4_pre', ...   
    'po4', ... 
    'o2', ...     
    'dop', ...     
    'fed', ...     
    'htotal', ...  
    'co3_ion', ... 
    'irr_mem', ... 
    'biomass_p', ... 
    'chl'};

n_bgc = size(bgc_tracers, 1);

if isfile(restartfile)
    load(restartfile)
else
    fprintf('start from %s\n', initfile)
    load('wet3d.mat');
    n_vec3d = sum(wet3d, 'all');
    aa.x = [];
    idx_start = [];
    idx_end = [];
    tracers = {};
    for i = 1:n_bgc
        fprintf('loading %s\n', bgc_tracers{i})
        invar = ncread(initfile, bgc_tracers{i});
        invec = invar(wet3d);
        aa.x = [aa.x; invec];
        % Append start and end indices for reading later
        idx_start = [idx_start; 1 + (i-1) * n_vec3d];
        idx_end = [idx_end; i * n_vec3d];
        % Save tracer names
        tracers = [tracers; bgc_tracers{i}];
    end
    
    save('indices.mat', 'idx_start', 'idx_end', 'tracers');

end

AAparams.mMax = 10;
AAparams.itmax = 60;
histParams.ncheckpointfreq = -1;
[xsol,iter,aa] = AndersonAcceleration(@g_bling, aa.x, [], histParams, restartfile);

