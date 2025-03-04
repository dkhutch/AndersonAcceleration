function [gx, gv, vnorms, externalconv] = g_wombat(x, fetchOutput, iter)

payudir = '/home/157/dkh157/ACCESS/pi_aa1';
scratchdir = '/scratch/y99/dkh157/access-esm/archive/pi_aa1';

indir = fullfile(scratchdir, 'restart000/ocean');
outdir = fullfile(scratchdir, 'restart001/ocean'); 
aa_outdir = fullfile(scratchdir, 'aa_output');

bgc_infile = fullfile(indir, 'csiro_bgc.res.nc');
sed_infile = fullfile(indir, 'csiro_bgc_sediment.res.nc');
bgc_outfile = fullfile(outdir, 'csiro_bgc.res.nc');
sed_outfile = fullfile(outdir, 'csiro_bgc_sediment.res.nc');

bgc_tracers = {'adic';'caco3';'alk';'dic';'no3'; ... 
               'phy';'o2';'fe';'zoo';'det'};
sed_tracers = {'caco3_sediment';'det_sediment'};
n_bgc = size(bgc_tracers, 1);
n_sed = size(sed_tracers, 1);

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
    for i = 1:n_sed
        fprintf('loading %s\n', sed_tracers{i})
        invar = ncread(sed_outfile, sed_tracers{i});
        % Convert 2D field into 1D vector and append to g(x)
        invec = invar(surf2d);
        gx = [gx; invec];
    end
else % run model
    bgc_save = fullfile(aa_outdir, sprintf('csiro_bgc.res_%04d.nc', iter));
    sed_save = fullfile(aa_outdir, sprintf('csiro_bgc_sediment.res_%04d.nc', iter));

    if iter == 0
        copyfile(bgc_infile, bgc_save);
        copyfile(sed_infile, sed_save);
    else 
        copyfile(bgc_outfile, bgc_save);
        copyfile(sed_outfile, sed_save);
        copyfile(bgc_outfile, bgc_infile);
        copyfile(sed_outfile, sed_infile);

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

        ncid = netcdf.open(sed_infile, 'NC_WRITE');
        for i = 1:n_sed
            j = i + n_bgc;
            fprintf('writing %s\n', sed_tracers{i})
            varid = netcdf.inqVarID(ncid, sed_tracers{i});
            % Need to remove (or rename) the checksum when modifying restart files
            netcdf.renameAtt(ncid, varid, 'checksum', 'old');
            % Extract each tracer using the start and end indices
            outvec = x(idx_start(j):idx_end(j));
            % Make it 2D and write to netcdf
            out2d = zeros(size(surf2d));
            out2d(surf2d) = outvec;
            netcdf.putVar(ncid, varid, out2d);
        end
        netcdf.close(ncid);     

    end

    fprintf('submit model run for iter = %d\n', iter)
    cd (scratchdir);
    if exist('restart001')
        !rm -r restart001 output001
    end
    cd (payudir);
    !payu run -n 1
end

vnorms = [];
externalconv = [];
gv = [];

end
