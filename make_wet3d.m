% make a logical mask for all ocean grid cells that are not NaN.
infile='/scratch/y99/dkh157/mom/archive/a15_c3_pik/output009/ocean_year.nc';
temp = ncread(infile, 'temp');
t1 = squeeze(temp(:,:,:,1));
wet3d = ~isnan(t1);

surf2d = squeeze(wet3d(:,:,1));

save('wet3d.mat', 'wet3d', 'surf2d');