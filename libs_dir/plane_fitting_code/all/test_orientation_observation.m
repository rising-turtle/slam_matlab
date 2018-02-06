function com_error = test_orientation_observation(snap_step)
global myCONFIG
config_file
% snap_step =1;
[x_k_k,p_k_k,q_expected] = read_snapshot(snap_step)

[T,q,R,varargout]=Calculate_V_Omega_RANSAC_dr_ye(snap_step-1,snap_step)
com_error = calc_orientation_error(x_k_k,snap_step,q_expected);


R_expected = q2R(q_expected);
R_estimated = q2R(x_k_k(4:7));
[m_, a_] = find_angle_bw_2_vecs(R_expected(:,2), R_estimated(:,2));
display_angles(m_, a_);
end

function [x_k_k,p_k_k,q_expected] = read_snapshot(snap_step)
global myCONFIG

load([myCONFIG.PATH.DATA_FOLDER,'DataSnapshots/','snapshot',num2str(snap_step),'.mat'])
features_info = eval(['snapshot',num2str(snap_step),'.features_info']);
filter = eval(['snapshot',num2str(snap_step),'.filter']);
[R,T] = plane_fit_to_data(snap_step);
x_k_k = get_x_k_k(filter);
p_k_k = get_p_k_k(filter);
q_expected = R2q(R');
x_k_k = x_k_k(1:7);
p_k_k = p_k_k (1:7,1:7);
end
function com_error = calc_orientation_error(x_k_k,snap_step,q_expected)

vect_est = q2R(x_k_k(4:7))*[0; 0 ;1];
vect_gt = q2R(q_expected)*[0; 0 ;1];


% com_error = euler_vec' - [zeros(size(gt_pan),1),gt_pan,zeros(size(gt_pan),1)];
[m_, a_] = find_angle_bw_2_vecs(vect_est, vect_gt);
display_angles(m_, a_);

h3 = mArrow3([0;0;0],vect_est,'color',[1 0 0]);

h4 = mArrow3([0;0;0],vect_gt,'color',[0 1 0]);
%         if i~=size(euler_vec,2)
delete(h3)
delete(h4)
%         end
% com_error(i,:) = R2e(e2R(euler_vec(:,i))*(e2R([0 gt_pan(i) 0]))');
com_error = a_(7) ;
end
% load([myCONFIG.PATH.DATA_FOLDER,'DataSnapshots/','snapshot',num2str(myCONFIG.STEP.END-1),'.mat'])
% features_info = eval(['snapshot',num2str(myCONFIG.STEP.END-1),'.features_info']);
% filter = eval(['snapshot',num2str(myCONFIG.STEP.END-1),'.filter']);
% if step==initIm+1
%     [R,T] = plane_fit_to_data(myCONFIG.STEP.END-1);
%     R=eye(3);
% end
% x_k_k_temp(1:7)
% x_k_k_temp = get_x_k_k(filter);
% stacked_x_k_k(:,step) = [R'*x_k_k_temp(1:3); R2q(R'*q2R( x_k_k_temp(4:7)))   ];
% %         [V,q]=calc_gt_in_1pointRANSAC(1,step);
% %         [V,q,time_gt]=get_gt_time(initIm,step);
% %         q=q';%% temperorily
% %         GroundTruth(:,step - initIm) = [V;q'];
% trajectory(:,step - initIm) = [R'*x_k_k_temp(1:3);  R2q(R'*q2R( x_k_k_temp(4:7)))];
% %         time_vector(step - initIm)=time_gt;
% p_k_k_temp = get_p_k_k(filter);
% stacked_p_k_k(:,:,step) = p_k_k_temp(1:7,1:7);
% step
% %         NormError(step - initIm)=norm(x_k_k_temp(1:3)-V);
% %
% for i=1:size(euler_vec,2)
%     vect_est = q2R(xx(4:7,i))*[1; 1 ;1];
%     vect_gt = e2R([0 gt_pan(i)*pi/180 0])*[0; 0 ;1];
%
%
%     % com_error = euler_vec' - [zeros(size(gt_pan),1),gt_pan,zeros(size(gt_pan),1)];
%     [m_, a_] = find_angle_bw_2_vecs(vect_est, vect_gt);
%     display_angles(m_, a_);
%
%     h3 = mArrow3([0;0;0],vect_est,'color',[1 0 0]);
%
%     h4 = mArrow3([0;0;0],vect_gt,'color',[0 1 0]);
%     if i~=size(euler_vec,2)
%         delete(h3)
%         delete(h4)
%     end
%     % com_error(i,:) = R2e(e2R(euler_vec(:,i))*(e2R([0 gt_pan(i) 0]))');
%     com_error(i,:) = a_(7) ;
% end