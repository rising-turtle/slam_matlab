function cov_pose_shift = calc_cov_RANSAC_dr_ye(step_1,step_2)
% config_file
global myCONFIG
Dr_Ye_File = [myCONFIG.PATH.DATA_FOLDER,'/RANSAC_pose_shift_dr_Ye/',...
    sprintf('RANSAC_RESULT_%d_%d.mat',step_1,step_2)];
% if DebugFlag || myCONFIG.FLAGS.RECALCULATE || (~myCONFIG.FLAGS.RECALCULATE && ~exist(Dr_Ye_File,'file'))
%     %%%% if you want to recalculate or if you do not want but there is no file available, run the RANSAC
%     [file1, err]=sprintf('%s/d1_%04d.dat',myCONFIG.PATH.DATA_FOLDER,stepPre);
%     [file2, err]=sprintf('%s/d1_%04d.dat',myCONFIG.PATH.DATA_FOLDER,stepCurrent);
%     if DebugFlag
%         [rot, phi, theta, psi, trans, error, pnum, op_num,sta,op_pset1,op_pset2,RANSAC_STAT] = vodometry_dr_ye(file1,file2,DebugFlag);
%         cprintf('-green',['Solution State is = ',sta])
%     else
%         [rot, phi, theta, psi, trans, error, pnum, op_num,sta,op_pset1,op_pset2,RANSAC_STAT] = vodometry_dr_ye(file1,file2);
%     end
%     if sta == 1
load(Dr_Ye_File,'op_pset1','op_pset2','sta','rot','trans','RANSAC_STAT')
%     end
Ya = op_pset1;
Yb = op_pset2;
R = rot;
T = trans;
q__ = R2q(R);
cov_pose_shift = cov_pose_shift_calc(Ya,Yb,R,T);
% delta_t= 0.1;
% if q__(1)<0.00001
%     cov_pose_shift_2 = [ (1/delta_t^2)*cov_pose_shift(1:3,1:3)  zeros(3,3);...
%         zeros(3,3)               diag( ((1*pi/(2*180*delta_t))) ^2 * [1 1 1] ) ];
%     
% else
%     [e__,de_dq,]=q2e(q__);
%     J_xq_xw = [eye(3)      zeros(3,4);...
%         zeros(3,3)  de_dq];
%     cov_pose_shift_2 = J_xq_xw*cov_pose_shift*J_xq_xw';
% end