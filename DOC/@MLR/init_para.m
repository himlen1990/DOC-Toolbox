function obj = init_para(obj,data)
    %
    % initialization the MLR class structure 
    %
    % input:
    % ------------------------------------------------------------------------------
    %   data: structure that contains features (X), classlabels (Y)
    %   and intensity labels (H)
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    % obj: an updated MLR class structure containing number of classes (Y)
    % number of features (F)
    % ------------------------------------------------------------------------------
    %

    tmp = [data{:}];
    try
        obj.Y = length(unique([tmp.Y]));
    catch error
        obj.Y = 1;
    end
    obj.F = size(data{1}.X,1);

end
