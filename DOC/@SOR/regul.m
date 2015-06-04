function [cost, grad, other] = regul(obj,O,other)
%————————————————————
% INFO:
% see ../@MLR/regul.m for description
%————————————————————


    cost = 0;
    cost = cost + obj.Lo * sum((O.a).^2); 
    cost = cost + obj.Lo * (log(O.sigma^2))^2; 

    grad = packages.STRUCT.mult(O,0);
    grad.a     = 2*obj.Lo*O.a;
    grad.sigma = obj.Lo*(4*log(O.sigma^2)/O.sigma);

end
