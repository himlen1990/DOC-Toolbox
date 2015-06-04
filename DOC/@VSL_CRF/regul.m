function [cost, grad, other] = regul(obj,O,other)
%————————————————————
% INFO:
% see ../@MLR/reguls.m for description
%————————————————————


    cost = 0;
    grad = packages.STRUCT.mult(O,0);


    for y_=1:length(O)
        if strcmp(obj.Type{y_},'n')
            [tmp, grad(y_), ~] = regul@HCRF(obj,O(y_),1);
        end
        if strcmp(obj.Type{y_},'o')
            [tmp, grad(y_), ~] = regul@HCORF(obj,O(y_),1);
        end
        cost = cost + tmp;
    end    
end
