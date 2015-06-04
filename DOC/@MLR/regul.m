function [cost, grad, other] = regul(obj,O,other)
    %
    % l2 regularization for MLR model
    %
    % input:
    % ------------------------------------------------------------------------------
    %  O: MLR model parameter
    %  other: experimetnal structure for passing different values during training
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    %  grad: gradients of regularization function
    %  cost: cost of regularization
    %  other: experimetnal structure for passing different values during training
    % ------------------------------------------------------------------------------
    cost = 0;
    grad = packages.STRUCT.mult(O,0);
    for y_=1:length(O.a)
        cost = cost + obj.Ln * sum((O.a{y_}(:)).^2); 
        grad.a{y_}=2*obj.Ln*O.a{y_};
    end    
end
