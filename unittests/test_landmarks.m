%
% works only under matlab 2015 
%
%addpath('../DOC')
%load('./test_landmarks.mat') 

%% use precomputed features
%set.iter = 50;
%set.parallel = 0;
%set.raw_landmarks = 0;
%mod = seq.tr('MLR',data,[0,0],set);
%pre = seq.pr(data,mod);
%res = packages.EVAL(data,pre)
%assert(res.Y.F1==1)


%% use raw landmargs 
%set.iter = 50;
%set.parallel = 0;
%set.raw_landmarks = 1;
%mod = seq.tr('MLR',data,[0,0],set);
%pre = seq.pr(data,mod);
%res = packages.EVAL(data,pre);
%assert(res.Y.F1==1)
