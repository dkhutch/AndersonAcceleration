% make a logical mask for all ocean grid cells that are not NaN.
infile='/scratch/y99/dkh157/access-esm/archive/pi_dh-pi_dh-b95a5a20/output000/ocean/ocean-3d-pot_temp-1monthly-mean-ym_0101_01.nc';
temp = ncread(infile, 'pot_temp');
t1 = squeeze(temp(:,:,:,1));
wet3d = ~isnan(t1);

surf2d = squeeze(wet3d(:,:,1));

save('wet3d.mat', 'wet3d', 'surf2d');