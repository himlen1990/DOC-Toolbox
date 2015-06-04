function [cll, grad, other, node_post_out, edge_post_out] = objective(obj,y,h,X,O,seq)
%————————————————————
% INFO:
% see ../@MLR/objective.m for description
%————————————————————


    other = [];


    for i = 1:obj.Y
        nom{i}=[];
        nom_pos{i}=[];
        ord{i}=[];
        ord_pos{i}=[];
    end

    for i = find(strcmp(obj.Type,'n'))
        if obj.v(obj.Class{i})=='n' | obj.v(obj.Class{i})=='?';
            nom_pos{obj.Class{i}}=i;
            nom{obj.Class{i}}=O{i};
        end
    end
    for i = find(strcmp(obj.Type,'o'))
        if obj.v(obj.Class{i})=='o' | obj.v(obj.Class{i})=='?';
            ord_pos{obj.Class{i}}=i;
            ord{obj.Class{i}}=O{i};
        end
    end

    for i = 1:obj.Y
        if ~isempty(ord{i})
            [node_potn.o{i}, edge_potn.o{i}, frac.o{i}] = obj.comp_potn(X, ord{i},'o');
            [node_post.o{i}, edge_post.o{i} logZ.o{i}] = inference.fwbw(node_potn.o{i}, edge_potn.o{i});
        else
            logZ.o{i}=-inf;
        end
        if ~isempty(nom{i})
            [node_potn.n{i}, edge_potn.n{i}, frac.n{i}] = obj.comp_potn(X, nom{i},'n');
            [node_post.n{i}, edge_post.n{i}, logZ.n{i}] = inference.fwbw(node_potn.n{i}, edge_potn.n{i});
        else
            logZ.n{i}=-inf;
        end

    end

    logZmix = [[logZ.n{:}]' [logZ.o{:}]'];

    if obj.init==0
        [logZ, set] = max(logZmix');
    else
        logZ=[];
        set = (rand(1,obj.Y)>0.5)+1;
        for i = 1:length(set)
            logZ(i) = logZmix(i,set(i));
        end
    end

    cll  = obj.comp_cll(logZ,y,h);

    % remove the losers
    Y.N=find(set==1);
    Y.O=find(set==2);

    for i = 1:obj.Y
        if any(i==Y.O)==0;
            ord{i}=[];
        end
        if any(i==Y.N)==0;
            nom{i}=[];
        end
    end

    % compute gradients
    grad_tmp = comp_grad(obj,y, node_potn, node_post,edge_post,X,nom,ord,logZ,frac);
    grad = packages.STRUCT.mult(O,0);
    for i = 1:obj.Y
        if ~isempty(nom_pos{i})
            if ~isempty(grad_tmp.n{i})
                grad{nom_pos{i}}=grad_tmp.n{i};
            end
        end
    end

    for i = 1:obj.Y
        if ~isempty(ord_pos{i})
            if ~isempty(grad_tmp.o{i})
                grad{ord_pos{i}}=grad_tmp.o{i};
            end
        end
    end
    for i = 1:length(set)
        if set(i)==1
            node_post_out{i}=node_post.n{i};
            edge_post_out{i}=edge_post.n{i};
        else
            node_post_out{i}=node_post.o{i};
            edge_post_out{i}=edge_post.o{i};
    end

    other.set = set;

end
