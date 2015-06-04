function O = initialize(obj,H,F)
%————————————————————
% INFO:
% see ../@MLR/initialize.m for describtion
%————————————————————

    rng('default');
    if nargin==1
        F=obj.F;
        H=obj.Y;
    end

    O.a = zeros(F,1);
    O.b1 = 0;
    O.d = ones(H-2,1);
    O.sigma = 1;

end
