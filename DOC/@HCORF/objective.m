function [cll, grad, other, node_potn, edge_potn] = objective(obj,Y,H,X,O,seq)
%————————————————————
% INFO:
% see ../@MLR/objective for description
%————————————————————

    other = [];

    for y_ = 1:obj.Y
        [node_potn{y_}, frac{y_}, edge_potn{y_}] = obj.comp_potn(X,O{y_});
    end


    for y_ = 1:obj.Y
        [node_post{y_} edge_post{y_} logZ(y_)] ... 
            = inference.fwbw(node_potn{y_}, edge_potn{y_});
    end

    cll  = obj.comp_cll(Y,H,logZ,node_potn,edge_potn);
    pxtr = exp( logZ(:) - repmat(inference.logsum(logZ(:),1),[length(O),1]) );
    for y_ = 1:obj.Y
        node_xpost{y_} = node_post{y_} * pxtr(y_);
        edge_xpost{y_} = edge_post{y_} * pxtr(y_);
    end

    if nargout==3
        grad = obj.comp_grad(Y,H,X,O,node_post,node_xpost,edge_post,edge_xpost,frac);
    else
        grad = 0;
    end

end
