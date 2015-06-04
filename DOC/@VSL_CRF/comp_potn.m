function [node_potn, frac, edge_potn] = comp_potn(obj,X,O,Type)
%————————————————————
% INFO:
% see ../@MLR/node_potn.m for description
%————————————————————



    if strcmp(Type,'n')
        [node_potn, edge_potn, frac] = comp_potn@HCRF(obj,X,O);
    else
        [node_potn, edge_potn, frac] = comp_potn@HCORF(obj,X,O);
    end

end
