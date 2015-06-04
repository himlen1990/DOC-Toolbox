function [cost, grad, other] = regul(obj,O,other)
%————————————————————
% INFO:
% see ../@MLR/regul for description
%————————————————————

    cost = 0;
    grad = packages.STRUCT.mult(O,0);

    for y_=1:length(O)
        [tmp,  grad{y_}, ~] = regul@SOR(obj, O{y_}, other);
        grad{y_}.u     = 2*obj.Lo*O{y_}.u;
        cost = cost + tmp;
        cost = cost + obj.Lo * sum(O{y_}.u(:).^2); 
    end    
end
