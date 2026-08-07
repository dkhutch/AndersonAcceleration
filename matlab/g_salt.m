function [gx, gv, vnorms, externalconv] = g_salt(x, fetchOutput, iter)

load('wet3d.mat');
load('info.mat');
load(vol_wt_file);

if fetchOutput
    fprintf('getting data from %s \n', Salt_fetch_file)
    Salt_3d = ncread(Salt_fetch_file,'passive_salt');
    Salt_vec = Salt_3d(wet3d);
    Salt_vec = Salt_vec .* vol_vec;
    gx = Salt_vec;
else
    fprintf('Putting AA Salt input run for iter = %d\n', iter)
    backup = fullfile(aa_out_dir, sprintf('ocean_passive.res_%04d.nc', iter));
    Salt_out = x;
    Salt_out = Salt_out ./ vol_vec;
    Salt_out3d = zeros(size(wet3d));
    Salt_out3d(wet3d) = Salt_out;
    if iter > 0
        ncwrite(Salt_put_file, 'passive_salt', Salt_out3d);
    end
    copyfile(Salt_put_file, backup);
end

vnorms = [];
externalconv = [];
gv = [];

end
