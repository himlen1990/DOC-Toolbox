addpath('../DOC')
load('test_observed_hidden_states')

%% settings
set.iter = 10;
set.parallel = 0;
set.observed_h = 1;
set.raw_landmarks = 0;
l1 = 1;
l2 = 0;

mod = seq.tr('HCRF',data,[l1,l2],set);
pre = seq.pr(data,mod);
res = packages.EVAL(data,pre)
assert(res.Y.F1==1);

mod = seq.tr('HCORF',data,[l1,l2],set);
pre = seq.pr(data,mod);
res = packages.EVAL(data,pre)
assert(res.Y.F1>0.6);
