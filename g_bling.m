function [gx, gv, vnorms, externalconv] = g_bling(x, fetchOutput, iter)

payudir = '/home/157/dkh157/mom/a15/a15_c1_bl_aa';
scratchdir = '/scratch/y99/dkh157/mom/archive/a15_c1_bl_aa';

restart_out = 'restart010';
restart_in = 'restart009';
bgc_outfile = fullfile(scratchdir, restart_out, 'ocean_bling.res.nc');
bgc_infile = fullfile(scratchdir, restart_in, 'ocean_bling.res.nc');
flux_outfile = fullfile(scratchdir, restart_out, 'ocean_bling_airsea_flux.res.nc'); 
flux_infile = fullfile(scratchdir, restart_in, 'ocean_bling_airsea_flux.res.nc'); 
ice_outfile = fullfile(scratchdir, restart_out, 'ice_bling.res.nc');
ice_infile = fullfile(scratchdir, restart_in, 'ice_bling.res.nc');

bgc_outdir = fullfile(scratchdir, 'aa_output');

load('wet3d.mat');
load('indices.mat');

n_bgc = size(bgc_tracers, 1);

if fetchOutput
    fprintf('getting data from %s \n', bgc_outfile)
    gx = [];
    for i = 1:n_bgc
        fprintf('loading %s\n', bgc_tracers{i})
        invar = ncread(bgc_outfile, bgc_tracers{i});
        % Convert 3D field into 1D vector and append to g(x)
        invec = invar(wet3d);
        gx = [gx; invec];
    end
else
    fprintf('submit model run for iter = %d\n', iter)
    backup = fullfile(bgc_outdir, sprintf('ocean_bling.res_%04d.nc', iter));
    if iter == 0
        copyfile(bgc_infile, backup);
    else 
        copyfile(bgc_outfile, backup);
        copyfile(bgc_outfile, bgc_infile);
        % Here we don't accelerate the flux and ice files, but we do update them...
        copyfile(flux_outfile, flux_infile);
        copyfile(ice_outfile, ice_infile);

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
    if exist(restart_out)
        !rm -r restart010 output010
    end
    cd (payudir);
    !payu run -n 1
end

vnorms = [];
externalconv = [];
gv = [];

end
