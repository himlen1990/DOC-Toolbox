function [node_potn, frac, edge_potn] = comp_potn(obj,X,O)
%————————————————————
% INFO:
% see ../@MLR/comp_potn.m for description
%————————————————————

    % init:
    L = size(X,2);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Node potential
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [node_potn, frac] = comp_pot(obj,X,O.a);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Edge potential
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    edge_potn=exp(O.u);

end

function [node_potn, frac] = comp_pot(obj,X,a)


        L = size(X,2);
        X = [X;ones(1,L)]; % (f+1)xL features
        Y = length(a);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   compute score for each class: 
        %
        %   Z(y) = exp( w(y) . x )                      [ Y X L ]
        %
        %
        node_potn = zeros(Y,L);
        for h_ = 1:Y
            A = repmat(a{h_},1,size(X,2));
            s(h_,:) = exp(sum(X.*A,1));
        end
        s = log(s./(repmat(sum(s,1),Y,1)));
        node_potn=exp(s);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   compute gradients at position x
        %
        %   g.a(y) = x                                  [ Y X L ]
        %
        for h_ = 1:Y;
            S = (repmat(node_potn(h_,:),size(X,1),1));
            frac.a{h_} = X ;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
