%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the data and split it into training set and a test set.
% simply uncomment that dataset that you want to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('DOC')

% Synthetic dataset with 1 class and 6 intensities each. 
% intensities are fully ordinal.
% This dataset was used in [1]
load('./data/corf_test.mat'); 


N = round(length(data)*0.75);
tr_data = data(1:N);     % 75% of the data for training
te_data = data(N+1:end); % 25% of the data for testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train a HCRF model with unobserved hidde nstates:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set.iter = 200;     % set the number of iteration for the gradient descent optimization
set.parallel = 0;   % apply method in parallel on all sequences
l1 = 1;                  % weight for l2 regularization

% Train one of the methods: 
% MLR:        Multinomial Logistic Regression
% SOR:       Static Ordinal Regression
% CRF:        Conditional Random Field 
% CORF:     Conditional Ordinal Random Field 

mod = seq.tr('CORF',tr_data,l1,set); % train a CRF model
pre = seq.pr(te_data,mod);           % predict labels using CRF model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res = packages.EVAL(te_data,pre)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% [1] M. Kim and V. Pavlovic. "Structured output ordinal regression for dynamic facial emotion 
% intensity prediction". Computer Vision - ECCV 2010. Daniilidis, Kostas, Maragos, Petros, 
% Paragios and Nikos eds. 2010. pp. 649-662.
