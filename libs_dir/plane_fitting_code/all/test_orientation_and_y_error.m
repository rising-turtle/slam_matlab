for snapshot_step=5:833
    snapshot_step
[angle1(snapshot_step),angle2(snapshot_step),angle3(snapshot_step),...
    xx,trajectory,cov_info]=test_the_effect_of_orinetation_(snapshot_step,2);
end
plot(angle1,'r');hold on;plot(angle2,'b');plot(angle3,'g')
e_VRO = abs(angle2 - angle3);
e_TRAJ = abs(angle1 - angle3);
figure
subplot(211)
plot(e_VRO,'r');hold on;plot(e_TRAJ,'b');
subplot(212)
plot(xx(2,:),'r');hold on;plot(trajectory(2,:),'b');
figure
plot(squeeze(cov_info(1,1,:)),'r');hold on;plot(squeeze(cov_info(2,2,:)),'b')
plot(squeeze(cov_info(3,3,:)),'g')