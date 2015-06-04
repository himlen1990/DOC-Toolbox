function pass = test()

    data=gen_data(100);
    init{1} = init_model();
    init{2} = init_model();
    init{1}.a{1}=[11;11];
    init{2}.a{1}=[22;22];


    settings = optimset(  ...
        'Display', 'iter', ...
        'Diagnostics', 'off', ...
        'Gradobj', 'on', ...
        'LargeScale','off', ...
        'MaxIter', 100, ...
        'MaxFunEval', 5000,...
        'TolX',1e-6 ...
        );

    res = packages.FMINUNC(@LinReg,init,settings,data);

    assert(eval(res{1},data)>0.8)


end





function model = init_model()
    model.a{1}=ones(2,1);
    model.a{2}=ones(2,1);
    model.b{1}=ones(1);
    model.b{2}=ones(1);
    model.c{1}=[4 3 1];
    model.d{1}=4;
end


function data = gen_data(n_examples,plot)
    rng('default');
    examples = [n_examples n_examples];
    mu = [0 0];
    Sigma = [.25 .3; .3 1];
    R1 = mvnrnd(mu,Sigma,examples(1))';
    Y1 = 1*ones(examples(1),1)';

    mu = [1 2];
    Sigma = [.25 .3; .3 1];
    R2 = mvnrnd(mu,Sigma,examples(2))';
    Y2 = 2*ones(examples(2),1)';

    x = [R1 R2];
    y = [Y1 Y2];


    rand_perm = randperm(length(x));

    data={};
    for i = randperm(length(x));
        tmp.x=x(:,i);
        tmp.y=y(i);
        data{end+1}=tmp;
    end

    if nargin==2
        tmp = [data{:}];
        X   = [tmp.x];
        Y   = [tmp.y];
        scatter(X(1,:),X(2,:),20,Y);
    end
end

function [ncll, grad] = LinReg(model,data)
    grad = packages.STRUCT.mult(model,0);
    cll = 0;
    for i = [1 2]
        grad{1}.a{i}=zeros(size(model{1}.a{i}));
        grad{1}.b{i}=zeros(size(model{1}.b{i}));
    end


    for i = 1:length(data)

        y = data{i}.y;
        x = data{i}.x;
        s = score(model{1},x);

        for y_ = [1 2];
            P(y_) = s(y_)/(s(1)+s(2));
        end

        cll = cll + log(P(y));

        for y_ = [1 2];
            grad{1}.a{y_} = grad{1}.a{y_} - x * (y_ == y) + P(y_) * x;
            grad{1}.b{y_} = grad{1}.b{y_} - 1 * (y_ == y) + P(y_) * 1;
        end
    end

    ncll = - cll;
end

function res = eval(model, data)
    for i = 1:length(data)

        x = data{i}.x;
        s = score(model,x);

        for y_ = [1 2];
            P(y_) = s(y_)/(s(1)+s(2));
        end
        [~, y] = max(P);
        res{i}.y=y;
    end

    tmp = [res{:}];  y_pr = [tmp.y];
    tmp = [data{:}]; y_gt = [tmp.y];
    res = sum(y_gt==y_pr)/length(y_pr);
end

function s = score(model,x)
    for y_ = [1 2];
        s(y_)=exp(model.a{y_}'*x+model.b{y_});
    end
end
