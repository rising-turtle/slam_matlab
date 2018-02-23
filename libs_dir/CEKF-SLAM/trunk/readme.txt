Compressed Extended Kalman Fileter-based SLAM simulator

by Zhang Haiqiang
Thanks to Tim Bailey and Juan Nieto for their code of EKF-SLAM 2004.Version 1.0

=========================================
To run this simulator:
1. load loop902.mat to the workspace
2. run "data = cekfslam(lm,wp)" in the command window
=========================================

+++++++++++++++++++++++++++++++++++++++++
2008-5-11
--Fix bugs when dealing with JXA.
--The covariance ellipses are drawn by a more visually convincingly manner.


2008-3-27
I'm working on the data association.

--Fix a bug in state augment

2007-11-22
This code works well under:
Linux Matlab7.4.0.336 (R2007a)
Windows Matlab 7.0.0.19920 (R14) on the loop902.mat.

HOWEVER, ONLY NUMBER_LOOPS= 1 works fine.

