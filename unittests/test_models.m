addpath('../DOC')
rng('default')
Seq = packages.GenSeqData;
data = Seq.generate(50);
tr = data(1:10);
te = data(11:end);

% experimantal settings
l1 = 1;
l2 = 1;
set.iter = 50;
set.parallel = 0;


counter = 0;
table = {};


% test static models
model = {};
model{end+1}='MLR';
model{end+1}='SOR';

for i = 1:length(model)
    counter = counter + 1;

    % select model 
    m = model{i};

    % train model
    mod = seq.tr(m,tr,[l1,l2],set);

    % predict test data
    pre = seq.pr(te,mod);

    % evaluate results
    res = packages.EVAL(te,pre);
    F1 = res.Y.F1;
    assert(F1>0.2)

    table{counter,1} = m;
    table{counter,2} = F1;
end


% test dynamic models
model = {};
model{end+1}='HCRF';
model{end+1}='HCORF';

for i = 1:length(model)
    counter = counter + 1;

    % select model 
    m = model{i};

    % train model
    mod = seq.tr(m,tr,[l1,l2],set);

    % predict test data
    pre = seq.pr(te,mod);

    % evaluate results
    res = packages.EVAL(te,pre);
    F1 = res.Y.F1;
    assert(F1>0.5)

    table{counter,1} = m;
    table{counter,2} = F1;
end


% test variable state models
model = {};
model{end+1}='VSL_CRF';
%model{end+1}='H_VSL_CRF';

for i = 1:length(model)
    counter = counter + 1;

    % select model 
    m = model{i};

    % train model
    mod = seq.tr(m,tr,[l1,l2],set);

    % predict test data
    pre = seq.pr(te,mod);

    % evaluate results
    res = packages.EVAL(te,pre);
    F1 = res.Y.F1;
    assert(F1>0.55)

    table{counter,1} = m;
    table{counter,2} = F1;
end
