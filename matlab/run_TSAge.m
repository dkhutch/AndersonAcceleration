payu_counter = 4;
scratch_dir = '/scratch/y99/dkh157/mom/archive/TS_c3_aa-063b0400';
payu_dir = '/g/data/y99/dkh157/mom/runs/a15/TS_c3_aa';
aa_out_dir = fullfile(scratch_dir, 'aa_output');

AAparams.mMax = 50;
AAparams.itmax = 50;
histParams.ncheckpointfreq = -1;

Temp_rest_file = 'temp_restart.mat';
Salt_rest_file = 'salt_restart.mat';
Age_rest_file = 'age_restart.mat';
wet_file = 'wet3d.mat';

load(wet_file);

put_dir = fullfile(scratch_dir, sprintf('restart%03d', payu_counter));
fetch_dir = fullfile(scratch_dir, sprintf('restart%03d', payu_counter + 1));
new_out_dir = fullfile(scratch_dir, sprintf('output%03d', payu_counter + 1))

Temp_fetch_file = fullfile(fetch_dir, 'ocean_passive.res.nc');
Salt_fetch_file = Temp_fetch_file;
Age_fetch_file = fullfile(fetch_dir, 'ocean_age.res.nc');

Temp_put_file = fullfile(put_dir, 'ocean_passive.res.nc');
Salt_put_file = Temp_put_file;
Age_put_file = fullfile(put_dir, 'ocean_age.res.nc');

save('info.mat', 'put_dir', 'fetch_dir', 'Temp_fetch_file', 'Salt_fetch_file', 'Age_fetch_file', ...
     'Temp_put_file', 'Salt_put_file', 'Age_put_file', 'aa_out_dir', 'payu_dir', 'scratch_dir');

if isfile(Temp_rest_file)
    aa = load(Temp_rest_file, 'aa');
else
    fprintf('start Temp from %s\n', Temp_put_file)
    Temp_3d = ncread(Temp_put_file, 'passive_temp');
    Temp_vec = Temp_3d(wet3d);
    aa.x = Temp_vec;
end

[xsol, iter, aa] = AndersonAcceleration(@g_temp, aa.x, [], histParams, Temp_rest_file);
clearvars aa;

if isfile(Salt_rest_file)
    aa = load(Salt_rest_file, 'aa');
else
    fprintf('start Salt from %s\n', Salt_put_file)
    Salt_3d = ncread(Salt_put_file, 'passive_salt');
    Salt_vec = Salt_3d(wet3d);
    aa.x = Salt_vec;
end

[xsol, iter, aa] = AndersonAcceleration(@g_salt, aa.x, [], histParams, Salt_rest_file);
clearvars aa;

if isfile(Age_rest_file)
    aa = load(Age_rest_file, 'aa');
else
    fprintf('start Age from %s\n', Age_put_file)
    Age_3d = ncread(Age_put_file, 'age_global');
    Age_vec = Age_3d(wet3d);
    aa.x = Age_vec;
end

[xsol, iter, aa] = AndersonAcceleration(@g_age, aa.x, [], histParams, Age_rest_file);
clearvars aa;

if exist(fetch_dir)
    delete(fullfile(fetch_dir, '*'));
    rmdir(fetch_dir);
end

if exist(new_out_dir)
    delete(fullfile(new_out_dir, '*'));
    rmdir(new_out_dir);
end

cd(payu_dir);
!payu run 
