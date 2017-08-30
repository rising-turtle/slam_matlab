function [ Row, Col] = Search_RowandCol(X, row, Y,col)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


  ex=1;
   
%   for k=[0 -1 1]
%    [temp,temp1]=find(X==row+k);%cor_j
%    [temp3,temp4]=find(Y==col);%cir_i
%    a=[temp,temp1];b=[temp3,temp4];
%    
%      for  i=1:size(a,1)
%        for j=1:size(b,1)
%          if a(i,:)==b(j,:)
%              row=a(i,:);
%              Row=row(1);
%              Col=row(2);
%              ex=0;
%              break;
%           end
%        end       
%      end    
%      
%      if ex==0
%          break;
%      end
%   end
%   
%   if ex==1
%    for k=[-1 1]
%       [temp,temp1]=find(X==row);%cor_j
%       [temp3,temp4]=find(Y==col+k);%cir_i
%       a=[temp,temp1];b=[temp3,temp4];
%    
%      for  i=1:size(a,1)
%        for j=1:size(b,1)
%          if a(i,:)==b(j,:)
%              row=a(i,:);
%              Row=row(1);
%              Col=row(2);
%              ex=0;
%              break;
%           end
%        end       
%      end    
%      
%      if ex==0
%          break;
%      end
%    end
%   end
  

% find accurate mapped points
  [temp,temp1]=find(X==row);%cor_j
   [temp3,temp4]=find(Y==col);%cir_i
   a=[temp,temp1];b=[temp3,temp4];
   
     for  i=1:size(a,1)
       for j=1:size(b,1)
         if a(i,:)==b(j,:)
             row=a(i,:);
             Row=row(1);
             Col=row(2);
             ex=0;
             break;
          end
       end       
     end    
  if ex==1
      Row=0;
      Col=0;
  end 

     
   
end

