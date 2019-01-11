tr = load('loc_path3.log'); 
tr = tr(2:end, 2:3); 
x = smooth(tr(:,1), 7);
y = smooth(tr(:,2), 7);

dis = 0;
for i=2:length(x)
    dis = dis + sqrt((x(i)-x(i-1))^2 + (y(i)-y(i-1))^2);
end
fprintf('trajectory lenth: %f meters', dis);
