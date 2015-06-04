function grad = comp_grad(obj,X,y,O,node_potn,frac)
    %
    % compute the gradients of one sequence 
    % of a MLR model 
    %
    % input:
    % ------------------------------------------------------------------------------
    %   X: Feature matrix with the size [n_features x n_frames]
    %   y: sequence label
    %   node_potn: node potentials for each class, each frame
    %   frac: gradients of of the node potentials 
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    %   grad: gradients of MLR model
    % ------------------------------------------------------------------------------


    grad = packages.STRUCT.mult(O,0);

    grad.a{y}=sum(frac.a{y},2);
    for y_ = 1:obj.Y
        grad.a{y_}=grad.a{y_}-frac.a{y_}*node_potn(y_,:)';
    end

end
