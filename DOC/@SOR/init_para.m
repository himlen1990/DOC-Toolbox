function obj = init_para(obj,data)
%————————————————————
% INFO:
% see ../@MLR/init_para.m for description
%————————————————————

    tmp = [data{:}];
    try
        obj.Y = length(unique([tmp.Y]));
    catch error
        obj.Y = 1;
    end
    obj.F = size(data{1}.X,1);

end
