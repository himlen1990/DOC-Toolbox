function O = init_model(obj,F,H,N)
%————————————————————
% INFO:
% see ../@MLR/init_model.m for description
%————————————————————

    rng('default');
    if nargin==1
        F=obj.F;
        H=obj.Hn;
        N=obj.Y;
    end

    for y_=1:N;
        O{y_}=init_model@MLR(obj,F,H);
        O{y_}.u=zeros(H);
    end
end
