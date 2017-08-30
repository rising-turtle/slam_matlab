function [ Col ] = SearchColumn( X,set_col,Thresh )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
N=size(X,2);
for i=1:N
    temp=find(X(:,i)==set_col);    
    num=size(temp,1);
    
%     switch num
%         case num>Thresh
%            Col=i;      
%         break;
%         otherwise
%         Col=0;  
%     end

    if(num>Thresh)
        Col=i;
        break;
    else
        Col=0;
end

   
    

end

