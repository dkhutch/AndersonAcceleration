function [gx, gv, vnorms, externalconv] = g_age(x, fetchOutput, iter)

payudir = '/home/157/dkh157/mom/a15/age_g2';
scratchdir = '/scratch/y99/dkh157/mom/archive/age_g2';

outfile = fullfile(scratchdir, 'restart500', 'ocean_age.res.nc');
infile = fullfile(scratchdir, 'restart499', 'ocean_age.res.nc');
age_outdir = fullfile(scratchdir, 'age_output');

load('wet3d.mat');

if fetchOutput
    fprintf('getting data from %s \n', outfile)
    age3d = ncread(outfile,'age_global');
    gx = age3d(wet3d);
else
    fprintf('submit model run for iter = %d\n', iter)
    backup = fullfile(age_outdir, sprintf('ocean_age.res_%04d.nc', iter));
    age_out = x;
    age_out3d = zeros(size(wet3d));
    age_out3d(wet3d) = age_out;
    if iter == 0
        copyfile(infile, backup);
    else 
        copyfile(outfile, backup);
        copyfile(outfile, infile);

        % need to get rid of checksum to restart with new age tracer
        ncid = netcdf.open(infile, 'NC_WRITE');
        varid = netcdf.inqVarID(ncid, 'age_global');
        netcdf.renameAtt(ncid,varid,'checksum', 'old');
        netcdf.close(ncid);
        ncwrite(infile, 'age_global', age_out3d);
    end
    cd (scratchdir);
    if exist('restart500')
        !rm -r restart500 output500
    end
    cd (payudir);
    !payu run -n 1
end

vnorms = [];
externalconv = [];
gv = [];

end
