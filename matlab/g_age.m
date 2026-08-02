function [gx, gv, vnorms, externalconv] = g_age(x, fetchOutput, iter)

load('wet3d.mat');
load('info.mat');

if fetchOutput
    fprintf('getting data from %s \n', Age_fetch_file)
    Age_3d = ncread(Age_fetch_file,'age_global');
    gx = Age_3d(wet3d);
else
    fprintf('Putting AA Age input run for iter = %d\n', iter)
    backup = fullfile(aa_out_dir, sprintf('ocean_age.res_%04d.nc', iter));
    Age_out = x;
    Age_out3d = zeros(size(wet3d));
    Age_out3d(wet3d) = Age_out;
    if iter > 0
        ncid = netcdf.open(Age_put_file, 'NC_WRITE');
        varid = netcdf.inqVarID(ncid, 'age_global');
        netcdf.close(ncid);
        ncwrite(Age_put_file, 'age_global', Age_out3d);
    end
    copyfile(Age_put_file, backup);

    if exist(fetch_dir)
        delete(fullfile(fetch_dir, '*'));
        rmdir(fetch_dir);
    end

    if exist(new_out_dir)
        delete(fullfile(new_out_dir, 'manifests/*'));
        rmdir(fullfile(new_out_dir, 'manifests'));
        delete(fullfile(new_out_dir, '*'));
        rmdir(new_out_dir);
    end

    cd(payu_dir);
    !payu run 
end

vnorms = [];
externalconv = [];
gv = [];

end
