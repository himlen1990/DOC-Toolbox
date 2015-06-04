function ANALYZE_DATA(data)
    N = length(data)
    H = {};
    Y = {};
    for i = 1:N
        H{end+1} = data{i}.H;
        Y{end+1} = data{i}.Y;
    end
    H = [H{:}];
    Y = [Y{:}];
    res_y = [];
    for i = unique(Y)
        res_y(end+1) = sum(i==Y)/double(length(Y));
    end
    res_h = [];
    for i = unique(H)
        res_h(end+1) = sum(i==H)/double(length(H));
    end
    res_h
    res_y
end
