function out = sim_soor()
    % Generate synthetic data -- 4 classes with 6 latent levels (nominal or
    % ordinal) from a Switching LDS
    
    tmp = {};

    p = drchrnd(5*[4;1;.3],6); % class 1
    C = [1;0;0;0];   % only n-th dim is relevant, all others will be noise % to be changed for different classes
    Q = .5; % state noise used to generate the intensity 
    R = 1; % change the feature noise (higher -- more difficult to predict the class
    tmp{end+1} = gen_class(p,C,Q,R,'o');

    p = drchrnd(10*[4;1;.3] ,6);  % class 2
    C = [1;.5;0;0.1];   % only n-th dim is relevant, all others will be noise % to be changed for different classes
    Q = .5; % state noise used to generate the intensity 
    R = 1; % change the feature noise (higher -- more difficult to predict the class
    tmp{end+1} = gen_class(p,C,Q,R,'o');

    p = drchrnd(10*[5;.5;0] ,6);  % class 3
    C = [0;0.1;2;0.1];   % only n-th dim is relevant, all others will be noise % to be changed for different classes
    Q = .5; % state noise used to generate the intensity 
    R = 1; % change the feature noise (higher -- more difficult to predict the class
    tmp{end+1} = gen_class(p,C,Q,R,'o');


    p = drchrnd(10*[6;.1;.2],6);  % class 4
    C = [0;0;0.2;1];   % only n-th dim is relevant, all others will be noise % to be changed for different classes
    Q = .5; % state noise used to generate the intensity 
    R = 1; % change the feature noise (higher -- more difficult to predict the class
    tmp{end+1} = gen_class(p,C,Q,R,'o');

    for i = 1:length(tmp)
        for j = 1:length(tmp{i})
            tmp{i}{j}.Y=i;
        end
    end

    tmp = [tmp{:}];
    out = tmp(randperm(length(tmp)));

end

function out = gen_class(p,C,Q,R,type)
    N = size(p,2);
    %transitiion matrix
    P = diag(p(1,:))+diag(p(2,1:end-1),-1)+diag(p(2,1:end-1),1)+diag(p(3,1:end-2),2); P(1,end)=p(end); % to be changed for different classes
    [M, z] = normalise(P',2);
    P=M';

    %init prob for the states
    p0 = [1;zeros(N-1,1)];

    % LDS with dynamics A, observation C
    A = p(1,:);
    M = 4;



    % Generate samples
    cP  = cumsum(P);
    cp0 = cumsum(p0);

    % number of sequences to generate
    K = 50;

    T = randn(1,K)*50+200; % their duration


    for k=1:length(T)

        r = rand(1);
        s{k}(1) = sum(r>cp0)+1;
        y{k}(1) = randn(1)*Q;
        x{k}(1:M,1) = C*y{k}(1) + randn(M,1)*R;

        for t = 2:T(k),

            r = rand(1);
            s{k}(t) = sum(r>cP(:,s{k}(t-1)))+1;

            y{k}(t) = A(s{k}(t))*y{k}(t-1) + randn(1)*Q;
            x{k}(1:M,t) = C*y{k}(t) + randn(M,1)*R;


        end

    end

    % Find thresholds to generate L levels from y
    L = 6;
    r = ksdensity(cell2mat(y), (1:(L-1))/L, 'function','icdf');

    % then threshold
    for k=1:K,
        yt{k} = sum(bsxfun(@lt,r',y{k}))+1;
    end

    out = {};
    for k=1:K,
        clear tmp;
        tmp.X = x{k};
        tmp.H = yt{k};
        clear tmp2
        if strcmp(type,'n')
            tmp2(tmp.H==1)=6;
            tmp2(tmp.H==2)=2;
            tmp2(tmp.H==3)=4;
            tmp2(tmp.H==4)=3;
            tmp2(tmp.H==5)=5;
            tmp2(tmp.H==6)=1;
            tmp.H = tmp2;
        end
        out{end+1}=tmp;
    end

end

function theta = drchrnd(alpha,n)

    p = length(alpha);
    r = zeros(p,n);

    if size(alpha,2)>size(alpha,1)
        alpha = alpha';
    end;   

    if 0   
        for i = 1:n
            theta(:,i) = gamrnd(alpha,1);
            theta(:,i) = theta(:,i) / sum(theta(:,i));
        end;       
    else
        % faster version
        theta = gamrnd(repmat(alpha,1,n),1,p,n);   
        theta = theta ./ repmat(sum(theta,1),p,1);
    end;
end



function [M, z] = normalise(A, dim)
    % NORMALISE Make the entries of a (multidimensional) array sum to 1
    % [M, c] = normalise(A)
    % c is the normalizing constant
    %
    % [M, c] = normalise(A, dim)
    % If dim is specified, we normalise the specified dimension only,
    % otherwise we normalise the whole array.

    if nargin < 2
        z = sum(A(:));
        % Set any zeros to one before dividing
        % This is valid, since c=0 => all i. A(i)=0 => the answer should be 0/1=0
        s = z + (z==0);
        M = A / s;
    elseif dim==1 % normalize each column
        z = sum(A);
        s = z + (z==0);
        %M = A ./ (d'*ones(1,size(A,1)))';
        M = A ./ repmatC(s, size(A,1), 1);
    else
        % Keith Battocchi - v. slow because of repmat
        z=sum(A,dim);
        s = z + (z==0);
        L=size(A,dim);
        d=length(size(A));
        v=ones(d,1);
        v(dim)=L;
        %c=repmat(s,v);
        c=repmat(s,v');
        M=A./c;
    end
end
