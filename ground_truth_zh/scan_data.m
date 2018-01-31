function [line_data, gt, gt_total] = scan_data (fid) % retrive data from file
%% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
lines=columns{1};
N=size(lines,1);
% frame_number = N-45; % frame_number is the frame number of dataset; (45 is the number of lines of data file header)
gt=[];
gt_total=[];
% figure;
start_frame_index = 0; %500; %2000; %2300; %1737;
finish_frame_index = intmax; %intmax; % ; %2600; %4000; %6300; %4146;

% check out number of valid and nonvalid
cnt_valid = 0;
cnt_invalid = 0;
cnt_b5 = 0; % count of points > 5

for i=1:N
    line_i=lines{i};
    line_data = textscan(line_i,'%s %d %f %f %f %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s','delimiter',',');
    if strcmp(line_data{1}, 'frame')
        if  ~isempty(line_data{6})
            if line_data{2} >= start_frame_index && line_data{2} <= finish_frame_index
                time_stamp = line_data{3};
                marker=[];
                if line_data{5} >= 5  % original
                    cnt_b5 = cnt_b5 + 1;
                    %if line_data{5} >= 3  % modified @06/14/2015
                    for m=1:line_data{5}
                        marker=[marker; [line_data{(m-1)*5+6},line_data{(m-1)*5+7},line_data{(m-1)*5+8}]];
                    end
                    if check_marker_pattern(marker) % good T pattern
                        pos =  mean(marker,1); %[x,y,z]; % [x,y,z]
                        gt= [gt; time_stamp, pos];
                        gt_total = [gt_total; time_stamp, reshape(marker', 1, 15)];%original
                        cnt_valid = cnt_valid + 1;
                    else
                        cnt_invalid = cnt_invalid + 1;
                    end
                    
                end
            end
        end
    end
end
fclose(fid);
fprintf('scan_data.m: cnt 5-points %d, crn valid %d cnt invalid %d\n', cnt_b5, cnt_valid, cnt_invalid);

end

