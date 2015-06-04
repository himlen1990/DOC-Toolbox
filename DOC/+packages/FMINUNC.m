function out = FMINUNC(fun,init,settings,data)

    [up, info] = Ccell2array(init);
    cell = array2Ccell(up,info);

    up = fminunc(@objective, up, settings);
    out = array2Ccell(up,info);

    function [f, g]= objective(up)
        model_struct = array2Ccell(up,info);
        [f,grad_struct] = fun(model_struct,data);
        g = Ccell2array(grad_struct);
    end

end

function cell = array2Ccell(array,info)
    if isstruct(info{1})
        cell = array2cell(array,info);
    else
        for i = 1:length(info)
            [cell{i} array] = array2cell(array,info{i});
        end
    end
end


function [cell array] = array2cell(array,info)

    for i = 1:length(info)
        obj = info{i};
        name{i}=obj.name{1};
        if strcmp(class(obj.size),'cell')
            clear cell_data 
            for j = 1:size(obj.size,1)
                for k = 1:size(obj.size,2)
                    [array, cell_data{j,k}] = get_data(array,obj.size{j,k});
                end
            end
            data{i}=cell_data ;
        else
            [array, data{i}] = get_data(array,obj.size);
        end
    end

    cell = cell2struct(data,name,2);

    function [array, data] = get_data(array,size)
        numel = prod(size);
        data = reshape(array(1:numel),size);
        array(1:numel)=[];
    end

end


function [out,info] = Ccell2array(Ccell)
    if iscell(Ccell)
        out = [];
        for i = 1:length(Ccell)
            [tmp info{i}] = cell2array(Ccell{i});
            out = [out;tmp];
        end
    else
        [out info] = cell2array(Ccell);
    end
end

function [out info] = cell2array(cell)
    info = {};
    out = [];
    for n = fieldnames(cell)'
        V = getfield(cell, char(n));
        info{end+1}.name=n;
        if iscell(V)
            for i = 1:size(V,1)
                for j = 1:size(V,2)
                    v = V{i,j};
                    info{end}.size{i,j}=size(v);
                    v = reshape(v,numel(v),1);
                    out = [out; v];
                end
            end
        else
            info{end}.size=size(V);
            V = reshape(V,numel(V),1);
            out = [out; V];
        end
    end
end
