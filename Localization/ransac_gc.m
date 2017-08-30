function [n_match, rs_match, cnum] = ransac_gc(pt1_noise, pt2_noise)

match=[];
for p=1:size(pt1_noise,2)
    match=[match [p p]'];
end

pnum = size(match, 2);

if(pnum<4)
    n_match=[];
    rs_match=[];
    cnum=-1;
    fprintf('number of points is smaller than 4: insufficient for ransac.\n');
    return;
end

for i=1:pnum
%     frm1_index=match(1, i);     frm2_index=match(2, i);
%     matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1));     ROW1=round(matched_pix1(2));
%     matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1));     ROW2=round(matched_pix2(2));
%     pset1(1,i)=-x1(ROW1, COL1);   pset1(2,i)=z1(ROW1, COL1);   pset1(3,i)=y1(ROW1, COL1);
%     pset2(1,i)=-x2(ROW2, COL2);   pset2(2,i)=z2(ROW2, COL2);   pset2(3,i)=y2(ROW2, COL2);
%     pset1(1,i)=x1(ROW1, COL1);   pset1(2,i)=y1(ROW1, COL1);   pset1(3,i)=z1(ROW1, COL1);
%     pset2(1,i)=x2(ROW2, COL2);   pset2(2,i)=y2(ROW2, COL2);   pset2(3,i)=z2(ROW2, COL2);
    pset1(1,i)=pt1_noise(1,i);   pset1(2,i)=pt1_noise(2,i);   pset1(3,i)=pt1_noise(3,i);
    pset2(1,i)=pt2_noise(1,i);   pset2(2,i)=pt2_noise(2,i);   pset2(3,i)=pt2_noise(3,i);    
end
minY = min(pset2(2,:));
pmY = find(pset2(2,:)==minY);
dist = sqrt(pset2(1,pmY(1))^2 + pset2(2,pmY(1))^2 + pset2(3,pmY(1))^2);

[rot, trans, sta] = find_transform_matrix(pset1, pset2);
%[phi, theta, psi] = rot_to_euler(rot); 

ns=4;
for i=1:ns
    num_rs(i) = round((pnum-1)*rand+1);
end

ind_dup1=(match(1, num_rs(1))==match(1, num_rs(2))) || (match(2, num_rs(1))==match(2, num_rs(2)));
ind_dup2=(match(1, num_rs(1))==match(1, num_rs(3))) || (match(1, num_rs(2))==match(1, num_rs(3))) || (match(2, num_rs(1))==match(2, num_rs(3))) || (match(2, num_rs(2))==match(2, num_rs(3)));
ind_dup3=(match(1, num_rs(1))==match(1, num_rs(4))) || (match(1, num_rs(2))==match(2, num_rs(4))) || (match(1, num_rs(3))==match(1, num_rs(4))) || (match(2, num_rs(1))==match(1, num_rs(4))) || (match(2, num_rs(2))==match(2, num_rs(4))) || (match(2, num_rs(3))==match(2, num_rs(4))) ;

while (num_rs(2)==num_rs(1)) || ind_dup1
    num_rs(2) = round((pnum-1)*rand+1);
    ind_dup1=(match(1, num_rs(1))==match(1, num_rs(2))) || (match(2, num_rs(1))==match(2, num_rs(2)));
end
while (num_rs(3)==num_rs(1)) || (num_rs(3)==num_rs(2)) || ind_dup2;
    num_rs(3) = round((pnum-1)*rand+1); 
    ind_dup2=(match(1, num_rs(1))==match(1, num_rs(3))) || (match(1, num_rs(2))==match(1, num_rs(3))) || (match(2, num_rs(1))==match(2, num_rs(3))) || (match(2, num_rs(2))==match(2, num_rs(3)));
end
while (num_rs(4) == num_rs(1)) || (num_rs(4) == num_rs(2)) || (num_rs(4) == num_rs(3)) || ind_dup3
    num_rs(4) = round((pnum-1)*rand+1);
    ind_dup3=(match(1, num_rs(1))==match(1, num_rs(4))) || (match(1, num_rs(2))==match(2, num_rs(4))) || (match(1, num_rs(3))==match(1, num_rs(4))) || (match(2, num_rs(1))==match(1, num_rs(4))) || (match(2, num_rs(2))==match(2, num_rs(4))) || (match(2, num_rs(3))==match(2, num_rs(4))) ;
end
    
for i=1:ns
%     frm1_index(i)=match(1, num_rs(i));    frm2_index(i)=match(2, num_rs(i));
%     matched_pix1=frm1(:, frm1_index(i));  COL1=round(matched_pix1(1));     ROW1=round(matched_pix1(2));
%     matched_pix2=frm2(:, frm2_index(i));  COL2=round(matched_pix2(1));     ROW2=round(matched_pix2(2));
%     rs_pset1(1,i)=-x1(ROW1, COL1);        rs_pset1(2,i)=z1(ROW1, COL1);    rs_pset1(3,i)=y1(ROW1, COL1);
%     rs_pset2(1,i)=-x2(ROW2, COL2);        rs_pset2(2,i)=z2(ROW2, COL2);    rs_pset2(3,i)=y2(ROW2, COL2);
%     rs_pset1(1,i)=x1(ROW1, COL1);        rs_pset1(2,i)=y1(ROW1, COL1);    rs_pset1(3,i)=z1(ROW1, COL1);
%     rs_pset2(1,i)=x2(ROW2, COL2);        rs_pset2(2,i)=y2(ROW2, COL2);    rs_pset2(3,i)=z2(ROW2, COL2);
    rs_pset1(1,i)=pt1_noise(1,num_rs(i));   rs_pset1(2,i)=pt1_noise(2,num_rs(i));   rs_pset1(3,i)=pt1_noise(3,num_rs(i));
    rs_pset2(1,i)=pt2_noise(1,num_rs(i));   rs_pset2(2,i)=pt2_noise(2,num_rs(i));   rs_pset2(3,i)=pt2_noise(3,num_rs(i)); 
    rs_match(:, i)=match(:, num_rs(i));
end

[rs_rot, rs_trans, rs_sta] = find_transform_matrix(rs_pset1, rs_pset2);
%[rs_phi, rs_theta, rs_psi] = rot_to_euler(rs_rot); 
pset21 = rs_rot*pset2;
for k=1:pnum
    pset21(:, k) = pset21(:, k) + rs_trans;
    d_diff(k) = 0.0;
    for(i=1:3)
        d_diff(k) = d_diff(k) + (pset21(i, k)- pset1(i, k))^2;
    end
end

good_pt = find(d_diff<0.001*dist);   
cnum = size(good_pt, 2);
if cnum == 0
    n_match=[];
    return;
end

for i=1:cnum
    n_match(:, i) = match(:, good_pt(i));
end
