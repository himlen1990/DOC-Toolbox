function grad = comp_grad(obj,y,node_potn,node_post,edge_post,X,nom,ord,logZ,frac)
%————————————————————
% INFO:
% see ../@MLR/comp_grad.m for description
%————————————————————


    pxtr = exp( logZ(:) - repmat(inference.logsum(logZ(:),1),[obj.Y,1]) );

    for y_ = 1:obj.Y

        if ~isempty(nom{y_})
            node_xpost.n{y_} = node_post.n{y_} * pxtr(y_);
            edge_xpost.n{y_} = edge_post.n{y_} * pxtr(y_);
        end

        if ~isempty(ord{y_})
        node_xpost.o{y_} = node_post.o{y_} * pxtr(y_);
        edge_xpost.o{y_} = edge_post.o{y_} * pxtr(y_);
        end

    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %   NOMINAL GRADIENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    for i = 1:length(nom)
        if ~isempty(nom{i})
            grad.n{i} = packages.STRUCT.mult(nom{i},0);
        else
            grad.n{i}=[];
        end
    end



    if ~isempty(nom{y})
    for h = 1:obj.Hn
        grad.n{y}.a{h} = frac.n{y}.a{h}*node_post.n{y}(h,:)'-frac.n{y}.a{h}*node_potn.n{y}(h,:)';
    end
        grad.n{y}.u = sum(edge_post.n{y},3);
    end

    for y_ = 1:obj.Y
        if ~isempty(nom{y_})
        for h = 1:obj.Hn
            grad.n{y_}.a{h} = grad.n{y_}.a{h} - frac.n{y_}.a{h}*node_xpost.n{y_}(h,:)';
            for h1 = 1:obj.Hn
                grad.n{y_}.a{h} = grad.n{y_}.a{h} + frac.n{y_}.a{h}*(node_xpost.n{y_}(h1,:).*node_potn.n{y_}(h,:))';
            end
        end
            grad.n{y_}.u = grad.n{y_}.u - sum(edge_xpost.n{y_},3);
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %   ORDINAL GRADIENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    for i = 1:length(nom)
        if ~isempty(ord{i})
            grad.o{i} = packages.STRUCT.mult(ord{i},0);
        else
            grad.o{i}=[];
        end
    end
    if ~isempty(ord{y})
        grad.o{y}.a       = sum(repmat(sum(node_post.o{y}.*frac.o{y}.a,1),[obj.F,1]).* (X), 2); 
        grad.o{y}.sigma   = sum(sum(node_post.o{y}.*frac.o{y}.sigma,1),2);
        grad.o{y}.b1      = sum(sum(node_post.o{y}.*frac.o{y}.b1,1), 2);    
        for j=1:(obj.Ho-2)
            grad.o{y}.d(j)= sum(sum(node_post.o{y}.*frac.o{y}.d{j},1), 2);
        end 
        grad.o{y}.u       = sum(edge_post.o{y},3);
    end

    for y_ = 1:obj.Y
        if ~isempty(ord{y_})
            grad.o{y_}.a        = grad.o{y_}.a        - sum(repmat(sum(node_xpost.o{y_}.*frac.o{y_}.a,1),[obj.F,1]).* (X), 2); 
            grad.o{y_}.sigma    = grad.o{y_}.sigma    - sum(sum(node_xpost.o{y_}.*frac.o{y_}.sigma,1), 2);
            grad.o{y_}.b1       = grad.o{y_}.b1       - sum(sum(node_xpost.o{y_}.*frac.o{y_}.b1,1), 2);
            for j=1:obj.Ho-2,
                grad.o{y_}.d(j) = grad.o{y_}.d(j)     - sum(sum(node_xpost.o{y_}.*frac.o{y_}.d{j},1), 2);
            end
            grad.o{y_}.u        = grad.o{y_}.u        - sum(edge_xpost.o{y_},3);
        end
    end
