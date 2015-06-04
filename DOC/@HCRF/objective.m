function [cll, grad, other, node_potn, edge_potn] = objective(obj,y,H,X,O,seq)
%————————————————————
% INFO:
% see ../@MLR/objective.m for description
%————————————————————
    other = [];

    for y_ = 1:obj.Y
        [node_potn{y_}, frac{y_}, edge_potn{y_}] = obj.comp_potn(X,O{y_});
    end


    for y_ = 1:obj.Y
        [node_post{y_} edge_post{y_} logZ(y_)] ... 
            = inference.fwbw(node_potn{y_}, edge_potn{y_});
    end


    cll  = obj.comp_cll(y,H,logZ,node_potn,edge_potn);


    if nargout==3
        grad = obj.comp_grad(y,H,X,O,node_potn,node_post,edge_post,logZ,frac);
    else
        grad = 0;
    end

end
