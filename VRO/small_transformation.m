function [b_small_move] = small_transformation(t)

global g_minimal_rotation g_minimal_translation 
b_small_move = 1; 

for i=1:3
    if t(i) > g_minimal_rotation
        b_small_move = 0;
        return;
    end
end

for i=4:6
    if t(i) > g_minimal_translation
        b_small_move = 0;
        return ;
    end
end

end