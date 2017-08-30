%%
% Aug. 16, 2016, David Z
% Transform a trajectory into a new reference 
function tp = transform_traj(p, iniT)

if nargin < 2
    iniT = [0.2 0.03 0.98 -0.43; 
            -0.98 -0.08 0.2 -0.29; 
            0.09 -1. 0.01 0.23; 
            0 0 0 1];
end
np = vect_T(iniT); 
tp = np; 
new_T = iniT; 
last_T = trans_T(p(1,:));
for i =2:size(p,1)
    cur_T = trans_T(p(i,:)); 
    del_T = last_T\cur_T; 
    new_T = new_T*del_T; 
    np = vect_T(new_T); 
    tp = [tp; np];
    
    last_T = cur_T;
end

end

function T = trans_T(p)
    R = quat2rmat(p(4:7)');
    t = p(1:3)'; 
    T = [R t; 0 0 0 1];
end

function p = vect_T(T)
    R = T(1:3,1:3); 
    t = T(1:3,4);
    q = rmat2quat(R); 
    p = [t' q'];
end

