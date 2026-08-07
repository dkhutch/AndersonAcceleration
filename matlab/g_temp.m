function [gx, gv, vnorms, externalconv] = g_temp(x, fetchOutput, iter)

load('info.mat');
load('wet3d.mat');
load(vol_wt_file);

if fetchOutput
    fprintf('getting data from %s \n', Temp_fetch_file)
    Temp_3d = ncread(Temp_fetch_file,'passive_temp');
    Temp_vec = Temp_3d(wet3d);
    Temp_vec = Temp_vec .* vol_vec;
    gx = Temp_vec;
else
    fprintf('Putting AA Temp input run for iter = %d\n', iter)
    backup = fullfile(aa_out_dir, sprintf('ocean_passive.res_%04d.nc', iter));
    Temp_out = x;
    Temp_out = Temp_out ./ vol_vec;
    Temp_out3d = zeros(size(wet3d));
    Temp_out3d(wet3d) = Temp_out;
    if iter > 0
        ncwrite(Temp_put_file, 'passive_temp', Temp_out3d);
    end
    % Don't copy file here because we do it for Salinity instead!
    % copyfile(Temp_put_file, backup);
end

vnorms = [];
externalconv = [];
gv = [];

end
