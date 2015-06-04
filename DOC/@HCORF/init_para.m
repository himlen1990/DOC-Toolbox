function obj = init_para(obj,data)
%————————————————————
% INFO:
% see ../@MLR/init_para for description
%————————————————————

    tmp = [data{:}];
    if obj.H_OBS==1
        try
            H = length(unique([tmp.H]));
        catch error
            H = 0;
        end
    else
        H=obj.Ho;
    end

    if H~=0
        obj.Ho=H;
    end

    obj=init_para@SOR(obj,data);

end
