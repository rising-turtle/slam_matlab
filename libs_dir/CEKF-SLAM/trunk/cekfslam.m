function data= cekfslam(lm, wp)
%function data= cekfslam(lm, wp)
%
% INPUTS: 
%   lm - set of landmarks
%   wp - set of waypoints
%
% OUTPUTS:
%   data - a data structure containing:
%       data.i            : number of states 
%       data.true        : the vehicle 'true'-path (ie, where the vehicle *actually* went)
%       data.path       : the vehicle path estimate (ie, where SLAM estimates the vehicle went)
%       data.state(k).x: the SLAM state vector at time k
%       data.state(k).P: the diagonals of the SLAM covariance matrix at time k
%       data.finalx      : the estimated states when a simulation is done
%       data.finalcov   : the estimated states covariance when a simulation is done
%       data.finalcorr  : the estimated states correlations when a simulation is done
%
%To run this simulator:
%   1. load loop902.mat to the workspace
%   2. run "data = cekfslam(lm,wp)" in the command window
%
% NOTES:
%   This program is a compressed extended Kalman filter(CEKF) based SLAM simulator. 
%   To use, create a set of landmarks and vehicle waypoints (ie, waypoints for the desired vehicle path). 
%   The program 'frontend.m' may be used to create this simulated environment - type
%   'help frontend' for more information.
%       The configuration of the simulator is managed by the script file
%   'configfile.m'. To alter the parameters of the vehicle, sensors, etc
%   adjust this file. There are also several switches that control certain
%   filter options.
%
% Thanks to Tim Bailey and Juan Nieto 2004.Version 1.0
%
% Zhang Haiqiang 2007-11-22
%
% ALGORITHM USED:
%   This program adopts Compressed Extended Kalman Filter to SLAM, and
%   when SWITCH_BATCH_UPDATE = 0, I used the sparsity of Observation
%   Jacobian Matrix to reduce computation complexity.
%
% MODELS:
%   The motion model is setup to be like a Pioneer3-AT robot(skid-steering),
%   The observation mode are setup to be like a LMS200.
%
% NOTES:
%   It is VERY important that the data association should always be
%   correct, if wrong data association occurs, the whole state will
%   probably diverge.
%
% Zhang Haiqiang 2007-11-20
% Zhang Haiqiang 2007-5-11
%

format compact
configfile;

% setup plots
if SWITCH_ANIMATION_ON == 1
    scrsz= get(0,'ScreenSize')*0.75;
    fig=figure('Position',[0 0 scrsz(3) scrsz(4)]);
    plot(lm(1,:),lm(2,:),'b*')
    hold on, axis equal, grid on
    %plot(wp(1,:),wp(2,:), 'g', wp(1,:),wp(2,:),'g.')
    MAXX = max([max(lm(1,:)) max(wp(1,:))]);
    MINX = min([min(lm(1,:)) min(wp(1,:))]);
    MAXY = max([max(lm(2,:)) max(wp(2,:))]);
    MINY = min([min(lm(2,:)) min(wp(2,:))]);
    axis([MINX-10 MAXX+10 MINY-10 MAXY+10])
    xlabel('metres'), ylabel('metres')
    set(fig, 'name', ' Compressed EKF-SLAM via Pioneer3-AT & LMS200')
    h= setup_animations;
    veh= 0.5*[1 1 -1 -1; 1 -1 1 -1]; % vehicle animation
    %plines=[]; % for laser line animation
    pcount=0;  
end
    
%
% zhq: 'stem' the diag of the state covariance matrix
%
if SWITCH_VISULIZE_THE_EVOLUTION_OF_COVARIANCE_DIAG == 1
    fig_DiagOfStateCovMatrix = figure;
    set( fig_DiagOfStateCovMatrix, 'Name', 'diag of the state covariance matrix');
    axes_DiagOfStateCovMatrix = axes;
end
%%%

% initialise states
global vtrue XA PA XB PB PAB
vtrue= zeros(3,1);% true pose of the vehicle
XA = zeros(3,1); % part A of SLAM state
PA = zeros(3);    %
XB = zeros(1);    % part B of SLAM state
PB = zeros(1);    %
PAB =zeros(1);   % cross covariance of part A and B

% CEKF auxiliary parameters
global PsiXB OmegaPB PhiPAB
PsiXB = zeros(1);
OmegaPB = zeros(1);
PhiPAB = zeros(1);
% CEKF 
global g_current_ala_center g_current_ala_center_cov
g_current_ala_center = zeros(2,1);
g_current_ala_center_cov = zeros(2);

% CEKF predict auxiliary parameter
global JXA 
JXA= zeros(1);

%
global GDATA

% initialise other variables and constants
dt= DT_CONTROLS; % change in time between predicts
dtsum= 0; % change in time since last observation
iwp= 1; % index to first waypoint 
W = 0; % initial rotation speed

% time lapsed since the vehicle started
g_sim_time = 0;

if SWITCH_OFFLINE_DATA_ON == 1  || SWITCH_ANIMATION_ON == 1
    initialise_store(); % stored data for off-line
end

QE= Q; RE= R; 
if SWITCH_INFLATE_NOISE, QE= 2*Q; RE= 8*R; end % inflate estimated noises (ie, add stabilising noise)
if SWITCH_SEED_RANDOM, randn('state',SWITCH_SEED_RANDOM), end

%
if SWITCH_PROFILE, profile on -detail mmex, end

% main loop 
counter = 0;
frame_counter= 0;
while iwp ~= 0
     g_sim_time= g_sim_time + dt;
     counter = counter+1;
    
    % zhq: visulize the diag of the state covariance matrix
    if SWITCH_VISULIZE_THE_EVOLUTION_OF_COVARIANCE_DIAG == 1
        dP = diag(PA);
        stem( axes_DiagOfStateCovMatrix, 1:length(dP), dP );
        set( axes_DiagOfStateCovMatrix, 'XLim', [1  length(dP)], 'XTick', 1: length(dP), 'YLim', [ 0 ceil(max(dP)+1e-9)],  'YTick', 0: ceil(max(dP)+1e-9)/10: ceil(max(dP)+1e-9) );
        if SWITCH_ANIMATION_ON == 0, drawnow, end
    end
    %%%
    
    % compute true data
    [W,iwp] = compute_rotationspeed(wp, iwp, AT_WAYPOINT, W, MAXW, dt);
    if iwp==0 && NUMBER_LOOPS > 1 
        iwp=1; 
        NUMBER_LOOPS= NUMBER_LOOPS-1; 
    end % perform loops: if final waypoint reached, go back to first
    
    vtrue = vehicle_model(vtrue, V, W,dt);
    [Vn, Wn] = add_control_noise (V,W,Q,SWITCH_CONTROL_NOISE);
    
    % CEKF predict step
    predict(Vn,Wn,QE, dt);

    % CEKF update step
    dtsum= dtsum + dt;
    %if dtsum >= DT_OBSERVE %zhq: dtsum >= DT_OBSERVE - 1e-6 is better
    if dtsum >= DT_OBSERVE - 1e-6 || iwp == 0
        dtsum= 0;
        [z]= get_observations(vtrue, lm, MAX_RANGE);
        z= add_observation_noise(z,R, SWITCH_SENSOR_NOISE);
    
        % try your best to make sure the data associate works correctly!
        [zf,idf, zn]= data_associate(XA,PA,z,RE, GATE_REJECT, GATE_AUGMENT); 
        check_data_association(idf);        
        
        if size(zf,1) > 0
            update(zf,RE,idf,SWITCH_BATCH_UPDATE); 
        else
            if size(PAB,1) ~= 1
                if size(PhiPAB,1) ~= 1
                    PhiPAB=JXA*PhiPAB;
                else
                    PAB=JXA*PAB;
                end
                JXA=zeros(1);
            end
        end
        
        if size(zn,1) >0, augment(zn,RE); end
        
        if switch_active_local_area(RESTRICING_ALA_R) ~= 0
            full_states_update();
            reassign_states(ENVIRONING_ALA_R);
        end        
    end
    
    % simulation is almost finished
    if  iwp == 0, full_states_update(); end
    
    % offline data store
    if SWITCH_OFFLINE_DATA_ON == 1, store_data(); end
    
    % plots
    if SWITCH_ANIMATION_ON == 1
        xt= TransformToGlobal(veh,vtrue);
        xv= TransformToGlobal(veh,XA(1:3));
        set(h.xt, 'xdata', xt(1,:), 'ydata', xt(2,:))
        set(h.xv, 'xdata', xv(1,:), 'ydata', xv(2,:))
        set(h.xfa, 'xdata', XA(4:2:end), 'ydata', XA(5:2:end))
        if size(XB,1) ~= 1, set(h.xfb, 'xdata', XB(1:2:end), 'ydata', XB(2:2:end)), end
        
        ptmp= make_covariance_ellipses(XA(1:3),PA(1:3,1:3));
        pcova(:,1:size(ptmp,2))= ptmp;
        if dtsum==0
            set(h.cova, 'xdata', pcova(1,:), 'ydata', pcova(2,:))             
            pcount= pcount+1;
            if pcount == 15 
                set(h.pth, 'xdata', GDATA.path(1,1:GDATA.i), 'ydata', GDATA.path(2,1:GDATA.i))    
                set(h.pthtrue, 'xdata', GDATA.true(1,1:GDATA.i), 'ydata', GDATA.true(2,1:GDATA.i))   
                pcount=0;
            end
            if ~isempty(z)
                plines= make_laser_lines (z,XA(1:3));
                set(h.obs, 'xdata', plines(1,:), 'ydata', plines(2,:))
                pcova= make_covariance_ellipses(XA,PA);
            end
            
            %set(h.timeelapsed, 'String', num2str(g_sim_time))
            
            if size(XB,1) ~= 1 && size(OmegaPB,1) == 1
                pcovb = make_covariance_ellipses_xb(XB,PB);
                set(h.covb, 'xdata', pcovb(1,:), 'ydata', pcovb(2,:))
            end
        end  
        
        [strict_circle, environ_circle] = make_range_circles(RESTRICING_ALA_R, ENVIRONING_ALA_R);
        set(h.restrict, 'xdata', strict_circle(1,:), 'ydata', strict_circle(2,:))
        set(h.environ, 'xdata', environ_circle(1,:), 'ydata', environ_circle(2,:))
        
        drawnow
        if SWITCH_RECORD_THE_PROCESS==1 && mod(counter,30) == 1,
            frame_counter= frame_counter+1;
            FRAMES(:,frame_counter)=getframe;
        end
    end   
end %end of while

if SWITCH_OFFLINE_DATA_ON == 1, finalise_data(); end

if SWITCH_ANIMATION_ON == 1
    set(h.pth, 'xdata', GDATA.path(1,:), 'ydata', GDATA.path(2,:))    
    set(h.pthtrue, 'xdata', GDATA.true(1,:), 'ydata', GDATA.true(2,:))  % zhq-draw true path
    set(h.timeelapsed, 'String', num2str(g_sim_time))
    drawnow
    if SWITCH_RECORD_THE_PROCESS == 1
        frame_counter= frame_counter+1;
        FRAMES(:,frame_counter)=getframe;
        movie2avi(FRAMES,'a.avi','quality',100);
    end
end


if SWITCH_PROFILE, profile report, end

GDATA.finalx = [XA; XB];
GDATA.finalcov = [PA PAB; PAB' PB];
vari = diag(GDATA.finalcov).^(1/2);
GDATA.finalcorr = GDATA.finalcov./ (vari*vari');

data= GDATA;
clear global vtrue XA PA XB PB PAB PsiXB OmegaPB PhiPAB 
clear global g_current_ala_center g_current_ala_center_cov
clear global JXA GDATA

%
%

function h= setup_animations()
h.xt= patch(0,0,'b','erasemode','xor'); % vehicle true
h.xv= patch(0,0,'r','erasemode','xor'); % vehicle estimate
h.pth= plot(0,0,'r.','markersize',2,'erasemode','background'); % vehicle path estimate
h.pthtrue= plot(0,0,'b.','markersize',2,'erasemode','background'); % vehicle path true
h.obs= plot(0,0,'k','erasemode','xor'); % observations
h.timeelapsed = annotation('textbox',[0.89 0.9 0.1 0.05]);
h.xfa= plot(0,0,'r+','erasemode','xor'); % estimated features of part A
h.cova= plot(0,0,'r','erasemode','xor'); % covariance ellipses
h.xfb= plot(0,0,'k+','erasemode','xor'); % estimated features of part B
h.covb= plot(0,0,'k','erasemode','xor'); % covariance ellipses
h.restrict= plot(0,0,'k','erasemode','xor', 'LineWidth',1, 'LineStyle','-');
h.environ= plot(0,0,'k','erasemode','xor', 'LineWidth',2, 'LineStyle','-');
%
%

function p= make_laser_lines (rb,xv)
% compute set of line segments for laser range-bearing measurements
if isempty(rb), p=[]; return, end
len= size(rb,2);
lnes(1,:)= zeros(1,len)+ xv(1);
lnes(2,:)= zeros(1,len)+ xv(2);
lnes(3:4,:)= TransformToGlobal([rb(1,:).*cos(rb(2,:)); rb(1,:).*sin(rb(2,:))], xv);
p= line_plot_conversion (lnes);

%
%

function p= make_covariance_ellipses(x,P)
% compute ellipses for plotting state covariances
N= 10;
inc= 2*pi/N;
phi= 0:inc:2*pi;

lenx= length(x);
lenf= (lenx-3)/2;
p= zeros (2,(lenf+1)*(N+2));

ii=1:N+2;
p(:,ii)= make_ellipse(x(1:2), P(1:2,1:2), 2, phi);

ctr= N+3;
for i=1:lenf
    ii= ctr:(ctr+N+1);
    jj= 2+2*i; jj= jj:jj+1;
    
    p(:,ii)= make_ellipse(x(jj), P(jj,jj), 2, phi);
    ctr= ctr+N+2;
end

%
%

function p= make_ellipse(x,P,s, phi)
% make a single 2-D ellipse of s-sigmas over phi angle intervals 
s=2.448; %corresponding cdf is 0.95
r= sqrtm(P);
a= s*r*[cos(phi); sin(phi)];
p(2,:)= [a(2,:)+x(2) NaN];
p(1,:)= [a(1,:)+x(1) NaN];

% % Use the following codes for a naive and visually better ellipse
% cdf=0.95;
% k=sqrt( -2*log(1-cdf) );
% px=P(1,1);py=P(2,2);pxy=P(1,2);
% if px==py,theta=pi/4; else theta=1/2*atan(2*pxy/(px-py));end
% r1=px*cos(theta)^2 + py*sin(theta)^2 + pxy*sin(2*theta);
% r2=px*sin(theta)^2 + py*cos(theta)^2 - pxy*sin(2*theta);
% T=[cos(theta) -sin(theta); sin(theta) cos(theta) ];
% pts=k*T*[sqrt(r1) 0; 0 sqrt(r2)]*[cos(phi); sin(phi)];
% p(1,:)=[pts(1,:)+x(1) NaN];
% p(2,:)=[pts(2,:)+x(2) NaN];

%
%

function p= make_covariance_ellipses_xb(x,P)
% compute ellipses for plotting state part B covariances
N= 10;
inc= 2*pi/N;
phi= 0:inc:2*pi;

lenx= length(x);
lenf= lenx/2;
p= zeros (2,(lenf)*(N+2));

ctr= 1;
for i=1:lenf
    ii= ctr:(ctr+N+1);
    jj= 2*i-1; jj= jj:jj+1;
    
    p(:,ii)= make_ellipse(x(jj), P(jj,jj), 2, phi);
    ctr= ctr+N+2;
end


%
%

function [circle1, circle2] = make_range_circles(r1, r2)
%
global g_current_ala_center
phi = 0:2*pi/50:2*pi;
aa = [cos(phi); sin(phi)];
circle1(1,:) = [r1*aa(1,:) + g_current_ala_center(1) NaN];
circle1(2,:) = [r1*aa(2,:) + g_current_ala_center(2) NaN];
circle2(1,:) = [r2*aa(1,:) + g_current_ala_center(1) NaN];
circle2(2,:) = [r2*aa(2,:) + g_current_ala_center(2) NaN];

%
%

function initialise_store()
% offline storage initialisation
global GDATA XA PA vtrue
GDATA.i=1;
GDATA.path= XA;
GDATA.true= vtrue;
GDATA.state(1).x= XA;
GDATA.state(1).P= diag(PA);

%
%

function store_data()
% add current data to offline storage
global GDATA XA XB PA PB vtrue
CHUNK= 5000;
if GDATA.i == size(GDATA.path,2) % grow array in chunks to amortise reallocation
    GDATA.path= [GDATA.path zeros(3,CHUNK)];
    GDATA.true= [GDATA.true zeros(3,CHUNK)];
end
i= GDATA.i + 1;
GDATA.i= i;
GDATA.path(:,i)= XA(1:3);
GDATA.true(:,i)= vtrue;
if size(XB,1) > 1
    GDATA.state(i).x= [XA; XB];
    GDATA.state(i).P= [diag(PA); diag(PB)]; 
else
    GDATA.state(i).x = XA;
    GDATA.state(i).P= diag(PA); 
end


%
%

function finalise_data()
% offline storage finalisation
global GDATA
GDATA.path= GDATA.path(:,1:GDATA.i);
GDATA.true= GDATA.true(:,1:GDATA.i);

function check_data_association(list)
%
a= sort(list);
if length(a) > 1
    for i = 1:1:length(a)-1,
        if (a(i+1)-a(i) < 0.5)
            list
            error('data association error!')
        end
    end
end
        
        