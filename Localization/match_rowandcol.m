function [ row, col ] = match_rowandcol( intensity,depth,ROW,COL )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
       n=size(intensity,2);
       for i=1:n
          if(intensity(:,i)==[ROW COL]')
              Temp=depth(:,i);
              row=Temp(1);
              col=Temp(2);
              break;
          end
end

