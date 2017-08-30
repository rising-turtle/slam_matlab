% Get global transformation for each data set
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 10/22/12

function [h_global] = get_global_transformation(data_index, dynamic_index, isgframe)

addpath('..\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');

% rx, ry, rz : [degree]
% tx, ty, tz : [mm]
rx=0;  ry=0;   rz=0;  tx=0;  ty=0;  tz=0;
 
switch data_index
    case 10  % square
        switch dynamic_index
            case 16
                %h_global = [euler_to_rot(0, -15.4, 0) [0 0 0]'; 0 0 0 1];      % square_700
                rx = -15.4;
        end
    case 11  % etas
        switch dynamic_index
            case 1
                %h_global = [euler_to_rot(0, -36.3, 0) [0 0 0]'; 0 0 0 1];       % etas
                %rx = -36.3;
                rx = -29.5089; ry = 1.1837; rz=3.6372;
            case 3
                rx = -28.9278; ry = 1.1894; rz=0.8985;
            case 5
                rx = -29.2181; ry = 1.1830; rz=1.8845;  
                
        end
    case 12  % loops
        switch dynamic_index
            case 2
                %h_global = [euler_to_rot(1.23, -25.6, 3.51) [0 0 0]'; 0 0 0 1];  % loops_2
                rx=-25.6;  ry=1.23;   rz=3.51;
            case 3
                %h_global =[euler_to_rot(1.2670, -24.3316, 4.6656) [0 0 0]'; 0 0 0 1]; %loops_3
                rx=-24.3316;  ry=1.2670;   rz=0; %4.6656; 
            case 13
                rx=-25.6109; ry=1.2418; rx=3.8448
                
        end
    case 13  % kinect_tum
        switch dynamic_index
            case 2
                % start image : 13050033527.670034
                % Groundtruth : 1305033527.6662 1.4906 -1.1681 0.6610 0.8959 0.0713 -0.0460 -0.4361
                init_qauterion = [0.8959, 0.0713, -0.046, -0.4361];
%                 temp_rot = q2R(init_qauterion);
%                 [r1, r2, r3] = rot_to_euler(temp_rot);
%                 r2d = 180 / pi;
%                 temp_rot = euler_to_rot(r2*r2d, r1*r2d, r3*r2d);
                temp_r = q2e(init_qauterion) * 180 / pi;
                %temp_rot = euler_to_rot(temp_r(2), temp_r(1), temp_r(3));  % degree
                %temp_rot = euler_to_rot(45, -45, 90) * temp_rot ;
                %[temp_r(2) temp_r(1) temp_r(3)] = rot_to_euler(temp_rot);
                temp_trans = [1.4906 -1.1681 0.661]*1000;
                %temp_r = temp_r * 180 / pi;
                rx = temp_r(1); ry = temp_r(2); rz = temp_r(3);
                %rx =0; ry =0; rz=0;
                tx = temp_trans(1);  ty = temp_trans(2);  tz = temp_trans(3);
        end
    case {14,15}  % loops2, amir_vro
        switch dynamic_index
            case 1
                %h_global =[euler_to_rot(1.2670, -24.3316, 4.6656) [0 0 0]'; 0 0 0 1]; %loops_3
                rx=-24.4985419798496;  ry=1.26190320102629;   rz=4.69088809909393; %4.6656;  
            case 2
                rx=-23.3420; ry=1.2739; rz=4.3772;
            case 3
                rx=-24.5234; ry=1.2565; rz=4.2682;
            case 4
                rx=-24.2726; ry=1.2606; rz=2.7462;
            case 5
                rx=-26.6191; ry=1.2173; rz=5.0601; %2.7462;
            case 6
                rx=-25.7422; ry=1.2396; rz=3.0821;
            case 7
                rx=-24.6791; ry=1.2562; rz=4.1917; %3.0821;
            case 8
                %h_global =[euler_to_rot(1.2670, -24.3316, 4.6656) [0 0 0]'; 0 0 0 1]; %loops_3
                rx=-23.8464;  ry=1.2721;   rz= 3.7964; %3.75437022813459;                
                %init_qauterion = [0.977813222516827,-0.206522692608165,0.00392574917797234,0.0348463456121639];
                %temp_r = q2e(init_qauterion) * 180 / pi;
                %rx = temp_r(1); ry = temp_r(2); rz = temp_r(3);
            case 9
                rx=-25.6806;  ry=1.2383;   rz=3.4203;
            case 10
                rx=-25.1216960394087;  ry=1.25311495911881;   rz=-0.909688742543562;
            case 11
                %h_global = [euler_to_rot(1.23, -25.6, 3.51) [0 0 0]'; 0 0 0 1];  % loops_2
                %rx=-25.6;  ry=1.23;   rz=3.51;
                rx=-33.7709;  ry=1.0903;   rz=3.0738;
            case 12  % same as exp 7
                rx=-24.6791; ry=1.2562; rz=4.1917; %3.0821;
        end
    case 16  % sparse_feature
        switch dynamic_index
            case 1
                rx=-29.9267;  ry=1.1978;   rz=0; %-2.6385; %4.69088809909393; %4.6656;   
            case 2
                rx=-28.7386;  ry=1.2247;   rz=0.8001; %-2.6385; %4.69088809909393; %4.6656; 
            case 3
                rx=-31.1218;  ry=1.1713;   rz=-1.7365;
            case 4
                rx=-29.3799;  ry=1.2133;   rz=-2.4075;
            case {5,6,7,8}
                rx = -39.1930; ry = 1.0134; rz = -1.2122;
            case {9, 10, 11}
                rx = -37.1533; ry = 1.0455; rz = -3.0266;
            case {12,16}
                rx = -38.3570; ry = 1.0315; rz = -0.3114;
            case 13
                rx=-28.3021; ry=1.2357; rz=-1.3391;
            case 14
                rx=-29.1073; ry=1.2133; rz=-0.5520;
        end
    case {17,18}  % swing
        switch dynamic_index
            case 1
                rx=-32.2179; ry=1.1567; rz=-1.1344;
            case 2
                rx=-28.6379; ry=1.2207; rz=-1.5099;
            case 3
                rx=-33.3490; ry=1.1279; rz=-3.1225;
            case 4 
                rx=-31.0073; ry=1.1770; rz=-0.6052;
            case 5
                rx=-31.7611; ry=1.1627; rz=-0.9156;
            case 7
                rx=-19.2560; ry=0.8450; rz=0.5809;
            case 8 
                rx=-17.5219; ry=0.8546; rz=-4.5522;
            case 9
                rx=-17.2286; ry=0.8616; rz=-3.4105;
            case 10
                rx=-18.1945; ry=0.8501; rz=1.4029;
            case 11
                rx=-18.2734; ry=0.8556; rz=0.2481;
            case 12
                rx=-24.4356; ry=0.7918; rz=-0.9333;
            case 13
                rx=-17.2649; ry=0.8549; rz=-2.8848;
            case 14
                rx=-20.1519; ry=0.8284; rz=-1.3661;
            case 15
                rx=-20.5691; ry=0.8302; rz=-0.7713;
            case 16
                rx=-19.8892; ry=0.8389; rz=-1.3603;
            case 17
                rx=-24.4211; ry=0.7959; rz=-3.0972;
            case 18
                rx=-21.7207; ry=0.8163; rz=-4.3600;
            case 19
                rx=-19.3202; ry=0.8454; rz=-2.7863;
            case 20
                rx=-20.2662; ry=0.8354; rz=-2.5763;
            case 21
                rx=-19.5310; ry=0.8403; rz=-1.9310;
            case 22
                rx=-18.3081; ry=0.8536; rz=-4.6978;
            case 23
                rx=-16.7653; ry=0.8678; rz=-4.2483;
            case 24
                rx=-16.4797; ry=0.8697; rz=-2.3778;
            case 25
                rx=-17.3060; ry=0.8587; rz=-3.1753;
            case 26
                rx=-16.9306; ry=0.8576; rz=-2.6512;
        end
    case {19}  % motive
        switch dynamic_index
            case 1
                rx=-22.2924; ry=0.8198; rz=-4.3367;
            case 2
                rx=-23.9217; ry=0.7990; rz=-3.1450;
            case 11
                rx=-17.5025; ry=1.3989; rz=-1.5120;
            case 12
                rx=-17.1856; ry=1.4018; rz=-0.3795;
            case 13
                rx=-16.8428; ry=0.8657; rz=-4.1148;
            case 15
                rx=-20.3861; ry=0.8323; rz=-4.4565;
            case 16
                rx=-21.2226; ry=0.8261; rz=-6.5253;
            case 17
                rx=-19.2100; ry=1.3724; rz=-4.0953;
            case 18
                rx=-18.4614; ry=1.3822; rz=-2.2221;
            case 19
                rx=-14.2685; ry=0.8810; rz=-2.4514;
            case 20
                rx=-14.8030; ry=0.8806; rz=-3.6865;
            case 21
                rx=-18.6913; ry=0.8436; rz=-1.3773;
            case 22
                rx=-15.3041; ry=0.8815; rz=0.3623;
            case 23
                %rx=-14.6923; ry=0.8813; rz=0.5994;
                rx=-15.8020; ry=0.8704; rz=-1.0940;
            case 24
                %rx=-13.9262; ry=0.8867; rz=2.9371;
                rx=-13.4739; ry=0.8915; rz=-3.8607;
            case 25
                %rx=-12.5003; ry=0.8973; rz=-1.6229;
                 rx=-12.5852; ry=0.8966; rz=-1.7487;
            case 26
                %rx=-13.1931; ry=0.8922; rz=0.3750;
                 rx=-13.1931; ry=0.8922; rz=0.3750;
            case 27
                rx=-13.7715; ry=0.8868; rz=0.7914;
            case 28
                rx=-14.2207; ry=0.8836; rz=-1.8911;
            case 29
                rx=-13.4205; ry=0.8920; rz=-1.8912;
            case 30
                rx=-15.2320; ry=0.8793; rz=-0.8757;
            case 31
                rx=-15.8020; ry=0.8704; rz=-1.0940;
            case 32
                rx=-18.3082; ry=1.3832; rz=2.6882;
            case 33
                rx=-18.3023; ry=1.3870; rz=-0.4907;
            case 34
                rx=-16.3416; ry=1.4141; rz=-1.3016;
            case 35
                rx=-15.9030; ry=1.4182; rz=-2.7589;
            case 36
                rx=-18.8863; ry=1.3755; rz=-4.6635;
            case 37
                rx=-15.9639; ry=1.4180; rz=0.1582;
        end
    case {20}  % object_recognition
        switch dynamic_index
            case 1
                rx=-37.7656; ry=1.0435; rz=-5.2416;
            case 2
                rx=-9.4696; ry=0.9351; rz=8.0194;
            case 3
                rx=-49.0312; ry=0.4693; rz=17.9271;
            case 4
                rx = -102.3278; ry=-0.4342; rz=-4.9235;
            case 5
                rx=-36.4384; ry=1.0755; rz=22.0853;
            case 6
                rx=-36.8751; ry=1.0886; rz=24.7719;
            case 7
                rx = -26.0697; ry=1.2667; rz=3.3011;
            case 8
                rx = -34.3278; ry=0.6732; rz=3.7436;
            case 9
                rx = -28.8132; ry=0.7380; rz=10.7045;
            case 10
                rx = -35.7148; ry=0.6569; rz=-10.9565;
            case 11
                rx = -27.3853; ry=0.7568; rz=-7.5140;
        end
    case {21}  % map
        switch dynamic_index
            case 2
                rx=-20.9872; ry=0.8237; rz= -1.6569;  
            case 3
                rx=-21.9661; ry=0.8124; rz=1.3211;
            case 4
                rx=-20.0099; ry=0.8344; rz=3.4412;
            case 5
                rx=-20.7988; ry=0.8285; rz=-1.4896;
            case 6
                %rx=-20.8341; ry=0.8281; rz=-1.5208;
                rx=-17.5434; ry=1.4023; rz=-0.4495;
            case 7
                rx=-19.7766; ry=1.3672; rz=-2.9528;
            case 8
                rx=-20.7362; ry=1.3549; rz=-3.8060;
            case 9
                rx=-17.1903; ry=1.4010; rz=0.2855;
        end
end

%h_global_tf = [euler_to_rot(0, 90, 0) [0 0 0]'; 0 0 0 1];
if strcmp(isgframe, 'gframe') 
    h_global = [e2R([rx*pi/180, ry*pi/180, rz*pi/180]) [tx ty tz]'; 0 0 0 1];
else
    %h_global = [euler_to_rot(ry, rx, rz) [tx ty tz]'; 0 0 0 1];
    h_global = [euler_to_rot(rz, rx, ry) [tx ty tz]'; 0 0 0 1];
end
%h_global = h_global * h_global_tf;
%h_global = [euler_to_rot(0, 0, 15) [tx ty tz]'; 0 0 0 1];
%h_global = [euler_to_rot(rz, rx, ry) [tx ty tz]'; 0 0 0 1];




%h_global = [euler_to_rot(0, 0, 0) [0 0 0]'; 0 0 0 1];  
%h_global = [euler_to_rot(0, -23.8, 0) [0 0 0]'; 0 0 0 1];       % square_1000
%init_qauterion = [0.8959, 0.0695, -0.0461, -0.4364];
%temp_rot = q2R(init_qauterion);
%[r1, r2, r3] = rot_to_euler(temp_rot);
%r2d = 180 / pi;
%temp_rot = euler_to_rot(r2*r2d, r1*r2d, r3*r2d);
%temp_r = q2v(init_qauterion) * 180 / pi;
%temp_rot = euler_to_rot(temp_r(2), temp_r(1), temp_r(3));  % degree
%temp_trans = [1.4908 -1.1707 0.6603]*1000;
%h_global = [temp_rot temp_trans'; 0 0 0 1];  % kinect_tum
%h_global_temp = [euler_to_rot(90, 0, 90) [0 0 0]'; 0 0 0 1];  % ?????
%h_global_temp = [[1 0 0; 0 0 -1; 0 1 0] [0 0 0]'; 0 0 0 1];
%h_global = h_global * h_global_temp;
%h_global = [euler_to_rot(0, 0, 0) temp_trans'; 0 0 0 1];

end