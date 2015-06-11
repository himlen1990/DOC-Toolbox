function O = init_model(obj,F,H,N)
%————————————————————
% INFO:
% see ../@MLR/init_model for description
%————————————————————

    rng('default');
    if nargin==1
        F=obj.F;
        H=obj.Ho;
        N=obj.Y;
    end

    for y_ = 1:N
        O{y_} =  init_model@SOR(obj,H,F);
        O{y_}.u= rand(H);
    end

end
