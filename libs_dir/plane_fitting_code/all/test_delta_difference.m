function test_delta_difference()
for snap_step =4:2000
    [T1,q1,R1]=Calculate_V_Omega_RANSAC_dr_ye(snap_step-1,snap_step);
    [T2,q1,R2]=Calculate_V_Omega_RANSAC_dr_ye(snap_step-2,snap_step-1);
    H=[R1 T1;0 0 0 1]*[R2' -R2'*T2;0 0 0 1];
    euler = 180*R2e(H(1:3,1:3))/pi;
    dT = H(1:3,4) ;
    norm_dT(snap_step) = norm(dT);
    norm_euler(snap_step) = norm(euler);
    norm_dT_percentage(snap_step) = 100*norm(dT)/norm(T1);
    norm_euler_percentage(snap_step) = 100*norm(euler)/norm(180*R2e(R1)/pi);
%     snap_step
end
figure;
subplot(211);plot(norm_dT*100,'b');hold on;xlabel('step');ylabel('norm error (cm)');title('transformation error introduced by using the previous step');grid on;
subplot(212);plot(norm_euler,'r');hold on;xlabel('step');ylabel('norm error (deg)');title('rotation error introduced by using the previous step');grid on;

figure;subplot(211);plot(norm_dT_percentage,'b');hold on;xlabel('step');ylabel('transformation error percentage');title('transformation error percentage introduced by using the previous step');grid on;
subplot(212);plot(norm_euler_percentage,'r');hold on;xlabel('step');ylabel('rotation error percentage ');title('rotation error percentage introduced by using the previous step');grid on;
