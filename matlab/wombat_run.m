restartfile = 'aa_restart.mat';
initdir = '/scratch/y99/dkh157/access-esm/archive/pi_aa1/restart000/ocean';

bgc_tracers = {'adic';'caco3';'alk';'dic';'no3'; ... 
               'phy';'o2';'fe';'zoo';'det'};
sed_tracers = {'caco3_sediment';'det_sediment'};

n_bgc = size(bgc_tracers, 1);
n_sed = size(sed_tracers, 1);

if isfile(restartfile)
    load(restartfile)
else
    fprintf('start from %s\n', initdir)
    load('wet3d.mat', 'wet3d', 'surf2d');
    n_vec3d = sum(wet3d, 'all');
    n_surf2d = sum(surf2d, 'all');
    bgc_file = fullfile(initdir, 'csiro_bgc.res.nc');
    sed_file = fullfile(initdir, 'csiro_bgc_sediment.res.nc');
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

    block1 = idx_end(end);

    for i = 1:n_sed
        fprintf('loading %s\n', sed_tracers{i})
        invar = ncread(sed_file, sed_tracers{i});
        % Convert 2D field to 1D vector and append to aa.x
        invec = invar(surf2d);
        aa.x = [aa.x; invec];
        % Append start and end indices for reading later
        idx_start = [idx_start; block1 + 1 + (i-1) * n_surf2d];
        idx_end = [idx_end; block1 + i * n_surf2d];
        % Save tracer names
        tracers = [tracers; sed_tracers{i}];
    end

    save('indices.mat', 'idx_start', 'idx_end', 'tracers');
end

AAparams.mMax = 10;
AAparams.itmax = 30;
histParams.ncheckpointfreq = -1;
[xsol,iter,aa] = AndersonAcceleration(@g_wombat, aa.x, AAparams, histParams, restartfile);

