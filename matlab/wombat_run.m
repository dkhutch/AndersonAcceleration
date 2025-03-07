restartfile = 'aa_restart.mat';
initdir = '/scratch/y99/dkh157/access-om2/archive/caco3dyn2_aa/restart008/ocean';

bgc_tracers = {'fe'; ...
    'alk'; ...
    'dicr'; ...
    'dicp'; ...
    'dic'; ...
    'caco3'; ...
    'detfe'; ...
    'det'; ...
    'zoofe'; ...
    'zoo'; ...
    'o2'; ...
    'phyfe'; ...
    'pchl'; ...
    'phy'; ...
    'no3'; ...
    'caco3_sediment'; ...
    'detfe_sediment'; ...
    'det_sediment'};

n_bgc = size(bgc_tracers, 1);

if isfile(restartfile)
    load(restartfile)
else
    fprintf('start from %s\n', initdir)
    load('wet3d.mat', 'wet3d', 'surf2d');
    n_vec3d = sum(wet3d, 'all');
    bgc_file = fullfile(initdir, 'ocean_wombatlite.res.nc');
    % Initialise aa.x vector:
    aa.x = [];
    idx_start = [];
    idx_end = [];
    tracers = {};
    for i = 1:n_bgc
        fprintf('loading %s\n', bgc_tracers{i})
        invar = ncread(bgc_file, bgc_tracers{i});
        % Convert 3D field to 1D vector and append to aa.x
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
AAparams.itmax = 30;
histParams.ncheckpointfreq = -1;
[xsol,iter,aa] = AndersonAcceleration(@g_wombatlite, aa.x, AAparams, histParams, restartfile);

