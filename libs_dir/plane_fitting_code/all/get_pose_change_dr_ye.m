function dpose = get_pose_change_dr_ye(pset1, pset2)
[rot, trans, state] = find_transform_matrix_dr_ye(pset1, pset2);
dpose = [trans;r2q(rot);state];