function [ output_args ] = plot_feature_pts( fname )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
    fname = 'vins_mono_ext_feature_pts.log';
end

pts = load(fname);

pts = filter_distant(pts);


hold on;
grid on; 
plot3(pts(:,1), pts(:,2), pts(:,3), '.', 'MarkerSize', 5);

view(3);
end

function pts = filter_distant(pts)
    
    epts = zeros(size(pts));
    k = 1;
    for i=1:size(pts, 1)
        good = true;
        for j=1:3
            if pts(i, j) > 40 || pts(i, j) < -40
                good = false;
                break;
            end
        end
        if good == true
            epts(k, :) = pts(i, :);
            k = k + 1;
        end
    end
    pts = epts(1:k,:);

end

