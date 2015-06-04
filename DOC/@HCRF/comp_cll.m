function cll = comp_cll(obj,Y,H,logZ,node_potn,edge_potn)
%————————————————————
% INFO:
% see ../@MLR/comp_cll.m for description
%————————————————————

    if obj.H_OBS==0 || isempty(H)
        cll = logZ(Y) - inference.logsum(logZ(:),1);
    else

        edge_potn{Y} = log(edge_potn{Y});
        node_potn{Y} = log(node_potn{Y});

        logZ=inference.logsum(logZ(:),1);
        [S T] = size(node_potn{Y});

        score = 0;


        tmp = sub2ind([S,T], H, 1:T);
        score = score + sum(node_potn{Y}(tmp));

        N = size(node_potn{Y},2);
        edge_potn_=repmat(edge_potn{Y},[1,1,N-1]);
        tmp = sub2ind([S,S,T-1], H(1:T-1), H(2:T), 1:T-1);
        score = score + sum(edge_potn_(tmp));
        cll   = score - logZ;

    end

end
