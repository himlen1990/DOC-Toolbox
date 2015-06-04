%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the data and split it into training and test sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('DOC')
ck = load('./data/ck.mat'); % ck dataset [INPUT: PCA processed locations of 20 facial points / OUTPUT: 6 emotion classes (and their  temporal segments,i.e., neutral->onset->apex)]
tr_data = ck.data(1:100);  %use first 100 sequences for training/validation 
te_data = ck.data(101:end);  %use the rest of sequences for testing (all in person independent manner)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train a HCRF model with unobserved hidde nstates:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set.iter = 100;     % set the number of iteration for the gradient descent optimization
set.parallel = 0;   % apply method in parallel on all sequences (otherwise, set it to 0)
set.observed_h = 0; % ignore intensity labels
l1 = 1;             % weight for l2 regularization
l2 = 0;             % weight for (second) l2 regularization (affects only VSL model as described in [1])

% Train one of the methods: 
%for prediction of
%emotion classes:
% HCRF:      Hidden Conditional Random Field 
% HCORF      Hidden Conditional Ordinal Random Field 
% VSL_CRF:   Variable State Conditional Random Field (max)
mod = seq.tr('VSL_CRF',tr_data,[l1,l2],set); % train a VSL_CRF model
pre = seq.pr(te_data,mod);         % predict class labels using VSL_CRF model  
res = packages.EVAL(te_data,pre)             % compute perfomance measures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[1]Variable-state Latent Conditional Random Fields for Facial Expression Recognition and Action Unit Detection
%R. Walecki, O. Rudovic, V. Pavlovic, M. Pantic. Proceedings of IEEE International Conference on Automatic Face and Gesture Recognition (FG'15). Ljubljana, Slovenia, pp. 1 - 8, May 2015.
