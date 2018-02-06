function plot_trajectory_with_steps(traj,varargin)
x=traj(1,:);
y=traj(2,:);
z=traj(3,:);
n_arguments = nargin;
if nargin==2
    time_stamp = varargin{1};
end
if nargin==3
    time_stamp = varargin{1};
    time_stamp_in_source = varargin{2};
end

% Define some data
% x = -100:100;
% y = x.^3;

% Set up a figure with a callback that executes on mouse motion, a set of
% axes, plot something in the axes, define a text object for later use.
figHdl = figure('WindowButtonMotionFcn', @hoverCallback);

axesHdl = axes;
axis(axesHdl,'equal')
axis(axesHdl,'auto')
% axis auto
% grid on
lineHdl = plot3(x, y,z, 'LineStyle', 'none', 'Marker', '.', 'Parent', axesHdl);
textHdl = text('Color', 'black', 'VerticalAlign', 'Bottom');

    function hoverCallback(src, evt)
        % Grab the x & y axes coordinate where the mouse is
%         mousePoint = get(axesHdl, 'CurrentPoint');
%         mouseX = mousePoint(1,1);
%         mouseY = mousePoint(1,2);
%         mouseZ = mousePoint(1,3);
% %         disp([num2str([mousePoint(1,1),mousePoint(1,2),mousePoint(1,3)]),'\n'])
%         
%         % Compare where data and current mouse point to find the data point
%         % which is closest to the mouse point
%         %         distancesToMouse = hypot(sqrt(hypot(x - mouseX, y - mouseY)),z - mouseZ);
%         distancesToMouse = hypot(x - mouseX, z - mouseZ);
%         [val, ind] = min(abs(distancesToMouse));
%         
%         % If the distance is less than some threshold, set the text
%         % object's string to show the data at that point.
%         xrange = range(get(axesHdl, 'Xlim'));
%         yrange = range(get(axesHdl, 'Ylim'));
%         zrange = range(get(axesHdl, 'Zlim'));
%         
%         if abs(mouseX - x(ind)) < 0.02*xrange && ...
%                 abs(mouseZ - z(ind)) < 0.02*zrange
%             
%             if n_arguments==1
%                 set(textHdl, 'String', {['x = ', num2str(x(ind))],...
%                     ['y = ', num2str(y(ind))],...
%                     ['z = ', num2str(z(ind))] });
%             end
%             if n_arguments==2
%                 set(textHdl, 'String', {['x = ', num2str(x(ind))],...
%                     ['y = ', num2str(y(ind))],...
%                     ['z = ', num2str(z(ind))],...
%                     ['t_{kf} = ', num2str(time_stamp(ind))] });
%             end
%             if n_arguments==3
%                 
%                 
%                 set(textHdl, 'String', {['x = ', num2str(x(ind))],...
%                     ['y = ', num2str(y(ind))],...
%                     ['z = ', num2str(z(ind))],...
%                     ['t_{kf} = ', num2str(time_stamp(ind))],...
%                     ['t_{src} = ', num2str(time_stamp_in_source(ind))] });
%             end
%             set(textHdl, 'Position', [x(ind) + 0.01*xrange, z(ind) + 0.01*zrange])
%         else
%             set(textHdl, 'String', '')
%         end
    end

end
