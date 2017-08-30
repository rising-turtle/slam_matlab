/*
	Author : David Zhang (hxzhang1@ualr.edu)
	Date : 11/09/2015
	ground truth, V1
*/

To use these functions, you must provide: 
	1) motion capture data
	2) your camera data record time sequence 
	NOTE: make sure data 1) and 2) start simultaneously
	3) the trajectory result of your SLAM methods

This folder has 3 modules to evaluate SLAM' result using the ground truth data: 
1 synchronization 
	main function: generate_gt_wpattern_syn_zh.m 
		INPUT: 1) motion capture data 2) camera timestamp data 
		1.1 synchorize_gt_record, synchronize these two time streams, find index pair (gt_index, cr_index), indicates 
		the first correspondence in the motion capture data and in the camera data; 
			NOTICE: 1 start motion capture data and camera data simultaneously !
					2 your SLAM method must start from camera frame cr_index!
		1.2 transform_pc, find the T pattern, and compute the transformation from motion capture coordinate 
		reference to the initial camera coordinate reference; 
			NOTICE: two cases of the T pattern may return, if the result is not right, change the cases in 
			compute_initial_T(), you can see the marker there case 1 or case 2;
		1.3 compute_transformation, use the T pattern, compute every [R,t] in each step, do not have to do 
		interpolation 
		
		1.4 the variable timestamp_offset in syn_time_with_gt.m needs manually set 
		
		OUTPUT: ground truth trajectory, you can see the plot there. 
		
2 ATE,RTE error computation 
	main function: compute_error.m
		INPUT: 1) ground truth trajectory, 2) estimated trajectory of your SLAM method 
		two modes can be selected : ATE, RTE, refer to paper kuemmerl09auro.pdf
		
		OUTPUT: mean, std, max, rmse of the translational and the rotational error (absolute/squared)
	main function: plot_ate_translation_error.m
		INPUT: 1) ground truth trajectory, 2) estimated trajectory of your SLAM method 
		ATE translation error is ploted framewise 
		
3 trajectory display 
	main function: plot_gt_and_estimate.m 
		INPUT: 1) ground truth trajectory, 2) estimated trajectory of your SLAM method 
		OUTPUT: you can see. 
		
notice: in compute_initial_T, there are two cases for computing the initial reference coordinate, have to check which case matches
This folder also contains three datasets and their result. You can run them as examples. 

Cheers. 
 