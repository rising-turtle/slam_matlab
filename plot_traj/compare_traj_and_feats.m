function compare_traj_and_feats(fdir )

    if nargin == 0
        fdir = './results/ETAS_2F_640_30';
        fdir = './results/ETAS_F2_640_30';
        fdir = './results/ETAS_4F_640_30';
        fdir = './results/ETAS_F4_640_30';
    end
    
    compare_trajectory(fdir); 
    hold on ; 
    
    f_feat = strcat(fdir, '/ETAS_2F_feats.log'); 
    f_feat = strcat(fdir, '/ETAS_F2_feats.log');
    f_feat = strcat(fdir, '/ETAS_4F_feats.log');
    f_feat = strcat(fdir, '/ETAS_F4_feats.log');
    
    plot_feature_pts(f_feat);
    view(2);

end