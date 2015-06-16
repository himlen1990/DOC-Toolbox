#  Dynamic Ordinal Classification (DOC) Toolbox - The User Manual

The Dynamic Ordinal Classification (DOC) Toolbox contains different sequence classification methods including Conditional Ordinal Random Fields (CORF), Hidden Conditional Ordinal Random Fields (HCORF), Conditional Random Fields (CRF) , Hidden Conditional Random Fields (HCRF) and Variable State Latent Conditional Random Fields (VSL-CRF).

This Toolbox is a collection of open source functions implemented in Matlab.









## *Download and installation*

#### 1) You can download the most recent version here -> [DOC-master.zip](https://github.com/RWalecki/DOC/archive/master.zip) <- or clone it directly from github:

```sh

$ git clone git@github.com:RWalecki/DOC.git

```

#### 2) Go to the working directory ('DOC' folder) and compile the c files by simply executing the make script

```matlab

make

```







## *Quick-start example*



The file '__DEMO_VSL_CRF.m__' contains an example of how to train the VSL_CRF [*] model and use it to predict sequence (class) labels.






The file '__DEMO_CORF.m__' contains an example of how to train the CORF [**] model and use it to predict sequence (class) labels.




 



The file '__DEMO_cross_validation_ck.m__' contains a script that applies a 3-fold cross-validation on the ck database for different methods.



The file '__DEMO_cross_validation_syn.m__' contains a script that applies a 3-fold cross-validation on synthetic data for different methods.

_[*] R. Walecki, O. Rudovic, V. Pavlovic, M. Pantic. "Variable-state Latent Conditional Random Fields for Facial Expression Recognition and Action Unit Detection",  Proceedings of IEEE International Conference on Automatic Face and Gesture Recognition (FG'15). pp. 1 - 8, 2015._

_[**] K. Minyoung and V. Pavlovic. "Structured output ordinal regression for dynamic facial emotion intensity prediction." European Conference on Computer Vision (ECCV). Springer Berlin Heidelberg, pp. 649-662. 2010._



## *Step by step guide*



#### Step 1: First of all, add the project source code to your working environment, load the data and split it into the training and test sets.

```matlab

addpath('DOC')          

ck = load('./data/ck.mat') 

tr_data = ck.data(1:100);        

te_data = ck.data(101:end);     

```

Note: the dataset is in a Matlab cell structure. Each sequence has the following properties:



> __X__: two dimensional feature matrix with the size: [ n-features x n-frames ]  (float)



> __Y__: sequence label with the size: [ 1 x 1 ]  (integer)



> __H__: frame label (optional) with the size: [ 1 x n-frames ] (integer)



#### Step 2: Set options and model parameters

Different settings can be applied to the training method by changing the properties of the 'set' structure. See an example below:

```matlab

set.iter = 100; 

set.parallel = 1; 

set.observed_h = 0; 

l1 = 0.01; 

l2 = 0.01; 

```

> iter: (uint), Number of iteration for the gradient descent optimization.



> parallel: (bool), run optimization on all sequences in parrallel.



> observed_h: (bool), train the model on observed hidden states. (works only, if H labels are given).



> l1: (float) first L-1 regularization parameter



> l2: (float) second L-1 regularization parameter (only used in the VSL-CRF model) 



#### Step 3: Training

```matlab

mod = seq.tr('VSL_CRF',tr_data,[l1,l2],set);

```

In this example, VSL_CRF is trained. Other models can be selected by simply replacing the first argument of the training function to:



##### Static models:

---------------------------------



> MLR: Multinomial logistic regression



> SOR: Static ordinal regression



#####Dynamic models (single class per sequence, varying states):



---------------------------------



> CRF:  Conditional Random Field 

> CORF: Conditional Ordinal Random Field



see: 

* K. Minyoung and V. Pavlovic. "Structured output ordinal regression for dynamic facial emotion intensity prediction." European Conference on Computer Vision (ECCV). Springer Berlin Heidelberg, pp. 649-662. 2010.*




##### Dynamic models (multi class):

---------------------------------



> HCRF:  Hidden Conditional Random Field 

> HCORF: Hidden Conditional Ordinal Random Field 



see:

* K, Minyoung, and V. Pavlovic. "Hidden conditional ordinal random fields for sequence classification." Machine Learning and Knowledge Discovery in Databases. Springer Berlin Heidelberg, 2010. 51-65. *



##### Dynamic models (multi class + multi state):

---------------------------------



> VSL_CRF:  Variable-State Conditional Random Fields



see: 
* R. Walecki, O. Rudovic, V. Pavlovic, M. Pantic. "Variable-state Latent Conditional Random Fields for Facial Expression Recognition and Action Unit Detection",  Proceedings of IEEE International Conference on Automatic Face and Gesture Recognition (FG'15). pp. 1 - 8, 2015.*

---------------------------------



#### Step 4: Prediction

The predictions are computed by using the 'seq.pr' function. Simply pass your trained model and the training data to it. 

```matlab

pre = seq.pr(te_data,mod);

```



#### Step 5: Compute the performance measures

```matlab

res = packages.EVAL(te_data,pre)

```

The evaluation function returns the error measures for sequence classification and intensity prediction (if the labels are given).

It returns the following measures:



> mean absolute Error (MAE)



> root mean square (RMS)



> classification accuracy (ACC)



> f1-measure per class  (f1)



> (average) f1-measure (F1)



> intraclass correlation coefficient  (ICC(3,1))



> Pearson's correlation coefficient (PCC)



> confusion matrix (CM)



# License and Citations



DOC Toolbox is free of charge for research purposes only. For companies interested in licensing, please contact: orudovic@imperial.ac.uk



If you use this toolbox, please cite:



* "Variable-state Latent Conditional Random Fields for Facial Expression Recognition and Action Unit Detection", R. Walecki, O. Rudovic, V. Pavlovic, M. Pantic. Proceedings of IEEE International Conference on Automatic Face and Gesture Recognition (FG'15). Ljubljana, Slovenia, pp. 1 - 8, May 2015.

* "Multi-output Laplacian Dynamic Ordinal Regression for Facial Expression Recognition and Intensity Estimation", O. Rudovic, V. Pavlovic, M. Pantic. Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2012). Providence, USA, pp. 2634 - 2641, June 2012.
