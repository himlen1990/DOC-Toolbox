function cll = comp_cll(obj,logZ,y,H)
%————————————————————
% INFO:
% see ../@MLR/comp_cll.m for description
%————————————————————

    cll = logZ(y) - inference.logsum(logZ(:),1);
end
