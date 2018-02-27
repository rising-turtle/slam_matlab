%% transform into the coordinate of the first pose
function pose = transform_to_first(pose)
   Too = construct(pose(1, 2:8));
   Too_inv = inv(Too);
   
   for i=1:size(pose,1)
       Tii = construct(pose(i, 2:8));
       Ts2i = Too_inv * Tii; 
       [q, t] = deconstruct(Ts2i); 
       pose(i, 2:4) = t(:);
       pose(i, 5:8) = q(:);
   end
end