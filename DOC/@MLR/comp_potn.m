function [node_potn, frac] = comp_potn(obj,X,a)
    %
    % compute the node potentials of a MLR model
    %
    % input:
    % ------------------------------------------------------------------------------
    %   X: Feature matrix with the size [n_features x n_frames]
    %   a: sepparating hyperplane for each class
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    % node_potn: node potentials for each class, each frame
    % frac: gradients of vector a for each frame
    % ------------------------------------------------------------------------------


    L = size(X,2);
    X = [X;ones(1,L)]; % (f+1)xL features
    Y = length(a);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   compute score for each class: 
    %
    %   S(y) = exp( w(y) . x )                      [ Y X L ]
    %
    %
    node_potn = zeros(Y,L);
    for y_ = 1:Y
        node_potn(y_,:) = exp(sum(X.*repmat(a{y_},1,size(X,2)),1));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   compute node potentials 
    %
    %   P(y) = S(y_) / (S(y1)+S(y2)+S(y3)... )      [ Y X L]
    %
    %
    node_potn=node_potn./(repmat(sum(node_potn,1),Y,1)+obj.small);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   compute gradients at position x
    %
    %   g.a(y) = x                                  [ Y X L ]
    %
    for i = 1:length(a);
        frac.a{i}=X;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
