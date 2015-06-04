function [cll, grad, other, node_post , edge_potn] = objective(obj,y,h,X,O,seq)
    %
    % MLR objective functione
    %
    % input:
    % ------------------------------------------------------------------------------
    %   X: Feature matrix with the size [n_features x n_frames]
    %   y: sequence label [1]
    %   h: intensity label [n_frames]
    %   O: MLR model parameter
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    % cll: model conditional log likelihood 
    % grad: model gradients
    % other: experimetnal structure for passing different values during training
    % node_post: node posterior potentials for the sequence class y
    % edge_post: edge posterior potentials for the sequence class y (not needed for MLR)
    % ------------------------------------------------------------------------------

    other =[];
    edge_potn = 0;

    [node_potn, frac] = obj.comp_potn(X,O.a);

    cll = sum(log(node_potn(y,:)));

    grad = obj.comp_grad(X,y,O,node_potn,frac);
    node_post{1}=node_potn;

end
