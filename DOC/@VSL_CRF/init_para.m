function obj = init_para(obj,data)
%————————————————————
% INFO:
% see ../@MLR/init_para.m for description
%————————————————————


    obj=init_para@MLR(obj,data);

    %if no state information is given initial
    %model as fully unsupervised
    if isempty(obj.v)
        for i = 1:obj.Y
            obj.v=[obj.v '?'];
        end
    end

    Class={};
    Type={};

    for i = 1:length(obj.v)
        tmp = [];
        if strcmp(obj.v(i),'o') | strcmp(obj.v(i),'?')
            Class{end+1} = i;
            Type{end+1} = 'o';
        end
        if strcmp(obj.v(i),'n') | strcmp(obj.v(i),'?')
            Class{end+1} = i;
            Type{end+1} = 'n';
        end
    end
    obj.Type = Type;
    obj.Class = Class;


end
