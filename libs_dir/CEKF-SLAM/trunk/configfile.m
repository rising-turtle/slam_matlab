%%% Configuration file
%%% Permits various adjustments to parameters of the SLAM algorithm.
%%% See cekfslam.m for more information

%control parameters
V = 0.3; %transition speed(m/s)
MAXW = 30.0*pi/180.0; % maximum rotation speed(m/s)
DT_CONTROLS= 0.1; % seconds, time interval between control signals

%control noises
sigmaV = 0.03;
sigmaW = 3.0*pi/180.0;
Q = [sigmaV^2 0; 0 sigmaW^2];

% observation parameters
MAX_RANGE= 8.0; % metres
DT_TIMES = 5;       % predicts between two adjacent updates
DT_OBSERVE= DT_TIMES*DT_CONTROLS; % seconds, time interval between observations

% observation noises
sigmaR= 0.05; % metres
sigmaB= (1.0*pi/180.0); % radians
R= [sigmaR^2 0; 0 sigmaB^2];

% data association innovation gates (Mahalanobis distances)
GATE_REJECT= 4.0; % maximum distance for association
GATE_AUGMENT= 25.0; % minimum distance for creation of new feature
% For 2-D observation:
%   - common gates are: 1-sigma (1.0), 2-sigma (4.0), 3-sigma (9.0), 4-sigma (16.0)
%   - percent probability mass is: 1-sigma bounds 40%, 2-sigma 86%, 3-sigma 99%, 4-sigma 99.9%.

% waypoint proximity
AT_WAYPOINT= 0.3; % metres, distance from current waypoint at which to switch to next waypoint
NUMBER_LOOPS= 1; % number of loops through the waypoint list

% switches
SWITCH_CONTROL_NOISE= 1; % if 0, velocity and gamma are perfect
SWITCH_SENSOR_NOISE = 1; % if 0, measurements are perfect
SWITCH_INFLATE_NOISE= 0; % if 1, the estimated Q and R are inflated (ie, add stabilising noise)
SWITCH_SEED_RANDOM= 1; % if not 0, seed the randn() with its value at beginning of simulation (for repeatability)
SWITCH_BATCH_UPDATE= 0; % if 1, process scan in batch, if 0, process sequentially

SWITCH_PROFILE=0;
SWITCH_VISULIZE_THE_EVOLUTION_OF_COVARIANCE_DIAG = 0;
SWITCH_OFFLINE_DATA_ON = 1;
SWITCH_ANIMATION_ON = 1;

% compressed extended Kalman filter
RESTRICING_ALA_R = 0.9*MAX_RANGE; % for swiching the XA
ENVIRONING_ALA_R =  3*MAX_RANGE; % ensuring the observations are inside XA

%record the whole process
SWITCH_RECORD_THE_PROCESS=0;
