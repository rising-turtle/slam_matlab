function display_creative_data(fid)
%
% David Z, 3/7/2015 
% display creative data to probe the error when running creative data 
%

if nargin == 0
    global_def;
    fid = 1;
end

%% load the data 
global g_camera_type
[img, x, y, z, c] = LoadCreative_dat(g_camera_type, fid);

%% display it
figure
% subplot(211)
scatter3(x(:),y(:),z(:),[],double(img(:)));colormap gray
hold on
set(gcf, 'Renderer', 'openGL')
axis equal
xlabel('x');ylabel('y');zlabel('z');

end