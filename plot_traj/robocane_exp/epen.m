function e = epen(p1 , p2)

if nargin == 1
    p2 = [0, 20, 0]'; 
    % p2 = [35.5, 1.1, 0]';
end

e1 = p1 - p2; 
e = sqrt(e1'*e1);

end