function [x_k_k,p_k_k,dT1,dq1,dT2,dq2,q_expected] = read_snapshot(snap_step,varargin)
global myCONFIG
if nargin>1
    relative_path = varargin{1};
else
       relative_path = 'DataSnapshots';  
end
if nargin>2
    Flag_Plane_Fitting = varargin{2};
else
    Flag_Plane_Fitting = 0;
end
[dT1,dq1,tem]=Calculate_V_Omega_RANSAC_dr_ye(snap_step-1,snap_step);
[dT2,dq2,temp]=Calculate_V_Omega_RANSAC_dr_ye(snap_step-2,snap_step-1);

    
load([myCONFIG.PATH.DATA_FOLDER,relative_path,'/snapshot',num2str(snap_step),'.mat'])
features_info = eval(['snapshot',num2str(snap_step),'.features_info']);
filter = eval(['snapshot',num2str(snap_step),'.filter']);
if Flag_Plane_Fitting
[R,T] = plane_fit_to_data(snap_step);
else
    R=eye(3);
end
x_k_k = get_x_k_k(filter);
p_k_k = get_p_k_k(filter);

q_expected = R2q(R');
x_k_k = x_k_k(1:7);
p_k_k = p_k_k (1:7,1:7);
end
