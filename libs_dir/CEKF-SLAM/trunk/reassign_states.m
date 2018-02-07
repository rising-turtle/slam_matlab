function reassign_states(maxd)
%function reassign_states()
%
% This function is really simply implemented!
%

global XA XB PA PAB PB g_current_ala_center g_current_ala_center_cov

% set new active local area
g_current_ala_center = XA(1:2,:);
g_current_ala_center_cov = PA(1:2,1:2);

% reassign part A and B
if length(XB) == 1
    x = XA;
    p = PA;
else
    x = [XA; XB];
    p = [PA PAB; PAB' PB];
end

% firstly find ...
xa_features= []; % all index of features that should be assigned to XA
xb_features= [];
features_num = (length(x) -3) / 2;
for i = 1:features_num
    if distance( x(1:2,:), x(3+i*2-1:3+i*2,:) ) < maxd
       xa_features = [xa_features i];
    else
        xb_features = [xb_features i];
    end
end

% secondly, 
lenxa = length(xa_features);
lenxb = length(xb_features);
indexxb = 1;
for indexxa = lenxa:-1:1
    if indexxb <= lenxb && ( xa_features(indexxa) > xb_features(indexxb) ) % switch these two states
        %switch features:  xa_features(indexxa), xb_features(indexxb)
        Nx1S = 3 + 2*xa_features(indexxa) -1;
        Nx1E = Nx1S + 1;
        Nx2S = 3 + 2*xb_features(indexxb) -1;
        Nx2E = Nx2S + 1;
        
        tmp = x(Nx1S:Nx1E,:);
        x(Nx1S:Nx1E,:) =  x(Nx2S:Nx2E,:);
        x(Nx2S:Nx2E,:) = tmp;
        
        tmp = p(:,Nx1S:Nx1E);
        p(:,Nx1S:Nx1E) =  p(:,Nx2S:Nx2E);
        p(:,Nx2S:Nx2E) = tmp;
         
        tmp = p(Nx1S:Nx1E,:);
        p(Nx1S:Nx1E,:) =  p(Nx2S:Nx2E,:);
        p(Nx2S:Nx2E,:) = tmp;
        %
        indexxb = indexxb+1;
    else % done
        break;
    end
end   

%finally
lengthofxa = 3+lenxa*2;
XA = x(1:lengthofxa,:);
PA = p(1:lengthofxa,1:lengthofxa);
if lenxb ~= 0
    XB = x(lengthofxa+1:end,:);
    PAB = p(1:lengthofxa, lengthofxa+1:end);
    PB = p(lengthofxa+1:end,lengthofxa+1:end);
else
    XB = zeros(1);
    PAB = zeros(1);
    PB = zeros(1);
end

%check
%
%

function dist = distance(pt1,pt2)
%
delta = abs(pt1-pt2);
dist =sqrt(delta'*delta);

