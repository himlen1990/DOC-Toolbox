function O = init_model(obj)
%————————————————————
% INFO:
% see ../@MLR/init_model.m for description
%————————————————————



    rng('default');
    if isempty(obj.O_init)
        O = [];
        for i = obj.Type
            tmp = [];
            if strcmp(i,'o') 
                tmp = [tmp init_model@HCORF(obj,obj.F,obj.Ho,1)];
            end
            if strcmp(i,'n') 
                tmp = [tmp init_model@HCRF(obj,obj.F,obj.Hn,1)];
            end
            O = [O tmp];
        end
    else
        O=obj.O_init;
    end

end
