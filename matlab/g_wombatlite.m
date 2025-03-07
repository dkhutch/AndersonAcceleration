function [gx, gv, vnorms, externalconv] = g_wombatlite(x, fetchOutput, iter)

payudir = '/home/157/dkh157/access-om2/caco3dyn2_aa';
scratchdir = '/scratch/y99/dkh157/access-om2/archive/caco3dyn2_aa';

indir = fullfile(scratchdir, 'restart008/ocean');
outdir = fullfile(scratchdir, 'restart009/ocean'); 
aa_outdir = fullfile(scratchdir, 'aa_output');

bgc_infile = fullfile(indir, 'ocean_wombatlite.res.nc');
bgc_outfile = fullfile(outdir, 'ocean_wombatlite.res.nc');

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

load('wet3d.mat', 'wet3d', 'surf2d');
load('indices.mat', 'idx_start', 'idx_end');

if fetchOutput
    fprintf('getting data from %s \n', outdir)
    % Initialise g(x) vector:
    gx = [];
    for i = 1:n_bgc
        fprintf('loading %s\n', bgc_tracers{i})
        invar = ncread(bgc_outfile, bgc_tracers{i});
        % Convert 3D field into 1D vector and append to g(x)
        invec = invar(wet3d);
        gx = [gx; invec];
    end
else % run model
    bgc_save = fullfile(aa_outdir, sprintf('ocean_wombatlite.res_%04d.nc', iter));

    if iter == 0
        copyfile(bgc_infile, bgc_save);
    else 
        copyfile(bgc_outfile, bgc_save);
        copyfile(bgc_outfile, bgc_infile);

        ncid = netcdf.open(bgc_infile, 'NC_WRITE');
        for i = 1:n_bgc
            fprintf('writing %s\n', bgc_tracers{i})
            varid = netcdf.inqVarID(ncid, bgc_tracers{i});
            % Need to remove (or rename) the checksum when modifying restart files
            netcdf.renameAtt(ncid, varid, 'checksum', 'old');
            % Extract each tracer using the start and end indices
            outvec = x(idx_start(i):idx_end(i));
            % Make it 3D and write to netcdf
            out3d = zeros(size(wet3d));
            out3d(wet3d) = outvec;
            netcdf.putVar(ncid, varid, out3d);
        end
        netcdf.close(ncid);
    end

    fprintf('submit model run for iter = %d\n', iter)
    cd (scratchdir);
    if exist('restart009')
        !rm -r restart009 output009
    end
    cd (payudir);
    !payu run -n 1
end

vnorms = [];
externalconv = [];
gv = [];

end
