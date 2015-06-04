function grad = comp_grad(obj,Y,H,X,O,node_post,node_xpost,edge_post,edge_xpost,frac)
%————————————————————
% INFO:
% see ../@MLR/comp_grad for description
%————————————————————

    if ~isempty(H)
        T =  size(node_post{Y},2);
        hmap = sub2ind([obj.Ho,T], H, 1:T); 
        imap = zeros(obj.Ho,T);
        imap(hmap) = 1;
        node_post{Y}=imap;
        edge_post{Y}=zeros(obj.Ho,obj.Ho,T-1);

        for j=1:obj.Ho,
            for l=1:obj.Ho,
                tjls = find((H(2:T)==j) & (H(1:T-1)==l));
                if ~isempty(tjls),
                    edge_post{Y}(l,j,tjls)=1;            
                end
            end
        end 
    end


    grad = packages.STRUCT.mult(O,0);

    grad{Y}.a       = sum(repmat(sum(node_post{Y}.*frac{Y}.a,1),[obj.F,1]).* (X), 2); 
    grad{Y}.sigma   = sum(sum(node_post{Y}.*frac{Y}.sigma,1),2);
    grad{Y}.b1      = sum(sum(node_post{Y}.*frac{Y}.b1,1), 2);    
    for j=1:(obj.Ho-2)
        grad{Y}.d(j)= sum(sum(node_post{Y}.*frac{Y}.d{j},1), 2);
    end 
    grad{Y}.u       = sum(edge_post{Y},3);

    for y_=1:obj.Y

        grad{y_}.a        = grad{y_}.a     - sum(repmat(sum(node_xpost{y_}.*frac{y_}.a,1),[obj.F,1]).* (X), 2); 
        grad{y_}.sigma    = grad{y_}.sigma - sum(sum(node_xpost{y_}.*frac{y_}.sigma,1), 2);
        grad{y_}.b1       = grad{y_}.b1    - sum(sum(node_xpost{y_}.*frac{y_}.b1,1), 2);
        for j=1:obj.Ho-2
            grad{y_}.d(j) = grad{y_}.d(j)  - sum(sum(node_xpost{y_}.*frac{y_}.d{j},1), 2);
        end

        grad{y_}.u        = grad{y_}.u     - sum(edge_xpost{y_},3);

    end

end
