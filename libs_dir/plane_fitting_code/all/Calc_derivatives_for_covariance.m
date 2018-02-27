f_p1 = sym('f_p1','real');
f_p2 = sym('f_p2','real');
f_p3 = sym('f_p3','real');


f_n1 = sym('f_n1','real');
f_n2 = sym('f_n2','real');
f_n3 = sym('f_n3','real');


q1 = sym('q1','real');
q2 = sym('q2','real');
q3 = sym('q3','real');
q4 = sym('q4','real');

T1 = sym('T1','real');
T2 = sym('T2','real');
T3 = sym('T3','real');

f_p=[f_p1;f_p2;f_p3];
f_n=[f_n1;f_n2;f_n3];
q = [q1;q2;q3;q4];
T = [T1;T2;T3];


a=q1;b=q2;c=q3;d=q4;
% [a,b,c,d] = split(q);

aa = a^2;
ab = 2*a*b;
ac = 2*a*c;
ad = 2*a*d;
bb = b^2;
bc = 2*b*c;
bd = 2*b*d;
cc = c^2;
cd = 2*c*d;
dd = d^2;
%% R
R  = [...
    aa+bb-cc-dd    bc-ad          bd+ac
    bc+ad          aa-bb+cc-dd    cd-ab
    bd-ac          cd+ab          aa-bb-cc+dd];


%% dR_dq
[a2,b2,c2,d2] = deal(2*a,2*b,2*c,2*d);

dR_dq_ = [...
    [  a2,  b2, -c2, -d2]
    [  d2,  c2,  b2,  a2]
    [ -c2,  d2, -a2,  b2]
    [ -d2,  c2,  b2, -a2]
    [  a2, -b2,  c2, -d2]
    [  b2,  a2,  d2,  c2]
    [  c2,  d2,  a2,  b2]
    [ -b2, -a2,  d2,  c2]
    [  a2, -b2, -c2,  d2]];
dR_dq = cell(1,4);
dR_dq{1,1} = reshape(dR_dq_(:,1),3,3);
dR_dq{1,2} = reshape(dR_dq_(:,2),3,3);
dR_dq{1,3} = reshape(dR_dq_(:,3),3,3);
dR_dq{1,4} = reshape(dR_dq_(:,4),3,3);

d2R_dq2 = cell(4,4);
for i=1:4
    for j=1:4
        d2R_dq2{i,j} = diff(dR_dq{1,i},q(j),1);
    end
end

%% Error Function
E_ = 0.5*(f_p - (R*f_n+T))'*(f_p - (R*f_n+T));

%% dE_dT
dE_dT = [diff(E_,T1,1);...
    diff(E_,T2,1);...
    diff(E_,T3,1)];

matlabFunction(dE_dT, 'file', 'dE_dT_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});

%% dE_dq
dE_dq = [diff(E_,q1,1);...
    diff(E_,q2,1);...
    diff(E_,q3,1);...
    diff(E_,q4,1)];

matlabFunction(dE_dq, 'file', 'dE_dq_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});
                                                
                                                

%% d2E_dT2
d2E_dT2 = [ diff(dE_dT(1),T1,1) diff(dE_dT(1),T2,1) diff(dE_dT(1),T3,1);...
    diff(dE_dT(2),T1,1) diff(dE_dT(2),T2,1) diff(dE_dT(2),T3,1);...
    diff(dE_dT(3),T1,1) diff(dE_dT(3),T2,1) diff(dE_dT(3),T3,1)  ];

matlabFunction(d2E_dT2, 'file', 'd2E_dT2_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});

%% d2E_dq2
d2E_dq2 = [ diff(dE_dq(1),q1,1) diff(dE_dq(1),q2,1) diff(dE_dq(1),q3,1) diff(dE_dq(1),q4,1);...
    diff(dE_dq(2),q1,1) diff(dE_dq(2),q2,1) diff(dE_dq(2),q3,1) diff(dE_dq(2),q4,1);...
    diff(dE_dq(3),q1,1) diff(dE_dq(3),q2,1) diff(dE_dq(3),q3,1) diff(dE_dq(3),q4,1);...
    diff(dE_dq(4),q1,1) diff(dE_dq(4),q2,1) diff(dE_dq(4),q3,1) diff(dE_dq(4),q4,1)];
matlabFunction(d2E_dq2, 'file', 'd2E_dq2_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});


%% d2E_dTdq
d2E_dTdq = [ diff(dE_dq(1),T1,1) diff(dE_dq(1),T2,1) diff(dE_dq(1),T3,1) ;...
    diff(dE_dq(2),T1,1) diff(dE_dq(2),T2,1) diff(dE_dq(2),T3,1) ;...
    diff(dE_dq(3),T1,1) diff(dE_dq(3),T2,1) diff(dE_dq(3),T3,1) ;...
    diff(dE_dq(4),T1,1) diff(dE_dq(4),T2,1) diff(dE_dq(4),T3,1) ];
matlabFunction(d2E_dTdq, 'file', 'd2E_dTdq_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});


%% d2E_dTdq
d2E_dqdT = [diff(dE_dT(1),q1,1) diff(dE_dT(1),q2,1) diff(dE_dT(1),q3,1) diff(dE_dT(1),q4,1);...
            diff(dE_dT(2),q1,1) diff(dE_dT(2),q2,1) diff(dE_dT(2),q3,1) diff(dE_dT(2),q4,1);...
            diff(dE_dT(3),q1,1) diff(dE_dT(3),q2,1) diff(dE_dT(3),q3,1) diff(dE_dT(3),q4,1)];
        
matlabFunction(d2E_dqdT, 'file', 'd2E_dqdT_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});        
        
%% d2E_dTdq        
dE_dX = [dE_dT;dE_dq];
matlabFunction(dE_dX, 'file', 'dE_dX_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});    

%% d2E_dTdq
d2E_dX2 = [d2E_dT2,d2E_dqdT;d2E_dTdq,d2E_dq2];
matlabFunction(d2E_dX2, 'file', 'd2E_dX2_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]}); 
                                                
                                                
                                                
%% d2E_dfn_dX 
d2E_dfn_dX = [ diff(dE_dX(1),f_n1,1)  diff(dE_dX(1),f_n2,1)  diff(dE_dX(1),f_n3,1);...
               diff(dE_dX(2),f_n1,1)  diff(dE_dX(2),f_n2,1)  diff(dE_dX(2),f_n3,1);...
               diff(dE_dX(3),f_n1,1)  diff(dE_dX(3),f_n2,1)  diff(dE_dX(3),f_n3,1);...
               diff(dE_dX(4),f_n1,1)  diff(dE_dX(4),f_n2,1)  diff(dE_dX(4),f_n3,1);...
               diff(dE_dX(5),f_n1,1)  diff(dE_dX(5),f_n2,1)  diff(dE_dX(5),f_n3,1);...
               diff(dE_dX(6),f_n1,1)  diff(dE_dX(6),f_n2,1)  diff(dE_dX(6),f_n3,1);...
               diff(dE_dX(7),f_n1,1)  diff(dE_dX(7),f_n2,1)  diff(dE_dX(7),f_n3,1)];
matlabFunction(d2E_dfn_dX, 'file', 'd2E_dfn_dX_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});       
                                                

%% d2E_dfp_dX 
d2E_dfp_dX = [ diff(dE_dX(1),f_p1,1)  diff(dE_dX(1),f_p2,1)  diff(dE_dX(1),f_p3,1);...
               diff(dE_dX(2),f_p1,1)  diff(dE_dX(2),f_p2,1)  diff(dE_dX(2),f_p3,1);...
               diff(dE_dX(3),f_p1,1)  diff(dE_dX(3),f_p2,1)  diff(dE_dX(3),f_p3,1);...
               diff(dE_dX(4),f_p1,1)  diff(dE_dX(4),f_p2,1)  diff(dE_dX(4),f_p3,1);...
               diff(dE_dX(5),f_p1,1)  diff(dE_dX(5),f_p2,1)  diff(dE_dX(5),f_p3,1);...
               diff(dE_dX(6),f_p1,1)  diff(dE_dX(6),f_p2,1)  diff(dE_dX(6),f_p3,1);...
               diff(dE_dX(7),f_p1,1)  diff(dE_dX(7),f_p2,1)  diff(dE_dX(7),f_p3,1)];
matlabFunction(d2E_dfp_dX, 'file', 'd2E_dfp_dX_4cov','vars', {[f_p1;f_p2;f_p3],...
                                                    [f_n1;f_n2;f_n3],...
                                                    [q1;q2;q3;q4],...
                                                    [T1;T2;T3]});    

%% heading observation                                                
n_p = simplify(cross(R(:,3),R(:,1)));
matlabFunction(n_p, 'file', 'observe_heading_func','vars',{[q1;q2;q3;q4]});    

%% heading observation jacobian
H = [diff(n_p(1),q1,1)  diff(n_p(1),q2,1)  diff(n_p(1),q3,1)  diff(n_p(1),q4,1);...
     diff(n_p(2),q1,1)  diff(n_p(2),q2,1)  diff(n_p(2),q3,1)  diff(n_p(2),q4,1);...
     diff(n_p(3),q1,1)  diff(n_p(3),q2,1)  diff(n_p(3),q3,1)  diff(n_p(3),q4,1)];
                                                
matlabFunction(H, 'file', 'observe_heading_jac','vars',{[q1;q2;q3;q4]});    



