function [cll, grad, other, node_post , edge_potn] = objective(obj,y,h,X,O,seq)
%————————————————————
% INFO:
% see ../@MLR/objective.m for description
%————————————————————


    other = [];

    [node_potn, frac] = obj.comp_potn(X,O);
    edge_potn = 0;

    cll = sum(log(node_potn(y,:)+obj.small));

    grad = obj.comp_grad(X,y,O,node_potn,frac);
    node_post{1}=node_potn;

end
