function [cov_pose_shift,q_dpose,T_dpose] = bootstrap_cov_calc(idx1,idx2)
% config_file
global myCONFIG
% step_1 = 6;
% step_2 = 7;


Dr_Ye_File = [myCONFIG.PATH.DATA_FOLDER,'/RANSAC_pose_shift_dr_Ye/',...
    sprintf('RANSAC_RESULT_%d_%d.mat',(idx1),(idx2))];
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
Ya = op_pset1';
Yb = op_pset2';
R = rot;
T = trans;
q__ = R2q(R);
q_dpose = q__;
T_dpose = T;
nData = size(op_pset1,2);
sampleSize = min(40,floor(0.75*nData));
nSamplePossible = factorial(nData)/(factorial(sampleSize)*factorial(nData - sampleSize));
nSample = min(50,nSamplePossible);

legitSamples = 0;
innov=zeros(7,7);
for i=1:nSample
    idxRand = randsample(1:size(op_pset1,2),sampleSize);
    
    dpose = get_pose_change_dr_ye(op_pset1(:,idxRand), op_pset2(:,idxRand));
    if dpose(end)==1
        legitSamples = legitSamples + 1;
        dpos_aggregate(:,legitSamples) = dpose(1:7);
        innov = innov + (dpose(1:7) -[T;q__])*(dpose(1:7) -[T;q__])';
    end
    
    
    
end
cov_pose_shift = (3/(legitSamples - 1))*innov;
% cov_pose_shift = cov_pose_shift_calc(Ya,Yb,R,T);

end
