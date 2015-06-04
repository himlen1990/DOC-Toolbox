function out = PREPROCESS(data,para)
    if nargin == 1
        [data img_center] = register(data);
        data = getXYdata(data);
        [data mapping] = pca(data,25);
        [data b s] = BVScalling(data);
        out.data = data;
        out.para.img_center = img_center;
        out.para.mapping = mapping;
        out.para.b=b;
        out.para.s=s;
    end
    if nargin == 2
        [data img_center] = register(data,para.img_center);
        data = getXYdata(data);
        [data mapping] = pca(data,25,para.mapping);
        [data b s] = BVScalling(data, para.b, para.s);
        out.data = data;
    end
end




function data = getXYdata(data)
    for i = 1:length(data)
        L = data{i}.Landmarks;
        X = [];
        for j = 1:length(L)
            X = [X L{j}(:)];
        end
        tmp.X=X;
        try
            tmp.Y=data{i}.Y;
        catch 
            %warning('no class labels')
        end
        try
            tmp.H=data{i}.H;
        catch 
            %warning('no intensity labels')
        end
        data{i}=tmp;
    end
end

function [data img_center] = register(data,img_center)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute mean image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin==1
        F=[];
        for i = 1:length(data)
            for j = 1:length(data{i}.Landmarks)
                LM = data{i}.Landmarks{j};
                f = [LM(:,1);LM(:,2)];
                F = [F f];
            end
        end
        F_mean = mean(F,2);
        X_center = F_mean(1:length(F_mean)/2);
        Y_center = F_mean(length(F_mean)/2+1:end);
        img_center = [X_center Y_center];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % register each image 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(data)
        for j = 1:length(data{i}.Landmarks)
            ps = data{i}.Landmarks{j};
            tnsim = fitgeotrans(ps,img_center, 'NonreflectiveSimilarity');
            data{i}.Landmarks{j}=transformPointsForward(tnsim,ps);
        end
    end
end

function [data b s] = BVScalling(data,b,s)
    if nargin == 1
        F = [];
        for i = 1:length(data)
            F = [F; data{i}.X'];
        end
        b = mean(F);
        s = std(F);
    end
    for i = 1:length(data)
        tmp = data{i}.X;
        B = repmat(b,[size(tmp,2),1])';
        S = repmat(s,[size(tmp,2),1])';
        tmp = (tmp-B)./S;
        data{i}.X = tmp;
    end
end

function [out mapping] = pca(data,N, mapping)
    F = [];
    for i = 1:length(data)
            F = [F data{i}.X];
    end
    if nargin == 2
        [F mapping] = MyPCA(F',N);F=F';
    else
        [F mapping] = MyPCA(F',N,mapping);F=F';
    end

    out={};
    k=0;
    for i = 1:length(data)
        L=size(data{i}.X,2);
        X=F(:,k+1:k+L);
        k=k+L;
        data{i}.X=X;
    end
    out = data;
end

function [mappedX, mapping] = MyPCA( X, no_dims, mapping)
    % Make sure data is zero mean
    if nargin == 2
        mapping.mean = mean(X, 1);
    end
    X = X - repmat(mapping.mean, [size(X, 1) 1]);


    % Perform eigendecomposition of C
    if nargin == 2
        C = cov(X);
        C(isnan(C)) = 0;
        C(isinf(C)) = 0;
        [M, lambda] = eig(C);

        % Sort eigenvectors in descending order
        [lambda, ind] = sort(diag(lambda), 'descend');
        if no_dims > size(M, 2)
            no_dims = size(M, 2);
            warning(['Target dimensionality reduced to ' num2str(no_dims) '.']);
        end
        M = M(:,ind(1:no_dims));
        var_tot=sum(lambda(1:no_dims))/sum(lambda);
        disp(['total variance: ' num2str(var_tot)])
        lambda = lambda(1:no_dims);
        mapping.M = M;
        mapping.lambda = lambda;
    end
    mappedX = X * mapping.M;
end
