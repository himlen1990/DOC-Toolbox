function grad = comp_grad(obj,Y,H,X,O,node_potn,node_post,edge_post,logZ,frac)
%————————————————————
% INFO:
% see ../@MLR/comp_grad.m for description
%————————————————————

    grad = packages.STRUCT.mult(O,0);
    pxtr = exp( logZ(:) - repmat(inference.logsum(logZ(:),1),[length(O),1]) );
    for y_ = 1:obj.Y
        node_xpost{y_} = node_post{y_} * pxtr(y_);
    end
    
    if ~isempty(H)
        T =  size(node_post{Y},2);
        hmap = sub2ind([obj.Hn,T], H, 1:T); 
        imap = zeros(obj.Hn,T);
        imap(hmap) = 1;
        node_post{Y}=imap;
        edge_post{Y}=zeros(obj.Hn,obj.Hn,T-1);

        for j=1:obj.Hn,
            for l=1:obj.Hn,
                tjls = find((H(2:T)==j) & (H(1:T-1)==l));
                if ~isempty(tjls),
                    edge_post{Y}(l,j,tjls)=1;            
                end
            end
        end 
    end


    for h = 1:obj.Hn
        grad{Y}.a{h} = frac{Y}.a{h}*node_post{Y}(h,:)'-frac{Y}.a{h}*node_potn{Y}(h,:)';
    end
    for y_ = 1:obj.Y
        for h = 1:obj.Hn
            grad{y_}.a{h} = grad{y_}.a{h} - frac{y_}.a{h}*node_xpost{y_}(h,:)';
            for h1 = 1:obj.Hn
                grad{y_}.a{h} = grad{y_}.a{h} + frac{y_}.a{h}*(node_xpost{y_}(h1,:).*node_potn{y_}(h,:))';
            end
        end
    end


    grad{Y}.u = sum(edge_post{Y},3);
    for y_ = 1:obj.Y
        grad{y_}.u = grad{y_}.u - sum( pxtr(y_) * edge_post{y_},3);
    end
end

