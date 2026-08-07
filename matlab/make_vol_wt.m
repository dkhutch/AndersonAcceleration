volfile = 'vol.nc';
wetfile = 'wet3d.mat';
outfile = 'vol_weight.mat';
outnc = 'vol_wt.nc';

vol = ncread(volfile, 'vol');
load(wetfile);

vol_vec = vol(wet3d);
vol_mean = mean(vol_vec);
vol_max = max(vol_vec);
vol_min = min(vol_vec);
vol_vec = vol_vec / vol_mean;

save(outfile, 'vol_vec');

vol_out3d = ones(size(wet3d)) * -1.0e10;
vol_out3d(wet3d) = vol_vec;
ncwrite(outnc, 'vol', vol_out3d);