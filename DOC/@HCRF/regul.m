function [cost, grad, other] = regul(obj,O,other)
%————————————————————
% INFO:
% see ../@MLR/regul.m for description
%————————————————————
    cost = 0;
    grad = packages.STRUCT.mult(O,0);
    for y_=1:length(O)
        [tmp grad{y_} ~] = regul@MLR(obj,O{y_},1);
        grad{y_}.u=2*obj.Ln*O{y_}.u;
        cost = cost + tmp;
        cost = cost + obj.Ln * sum((O{y_}.u(:).^2)); 
    end    
end
