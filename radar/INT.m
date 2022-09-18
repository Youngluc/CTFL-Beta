% --------------------------------INT.m--------------------------------
function [sum] = INT(x,t);
    n=length(x);
for i=1:n
    if i==1
        sum(i)=0;
    else
        sum(i)=sum(i-1)+(x(i)+x(i-1))*(t(i)-t(i-1))/2;
    end
end
end

