function O = init_model(obj,F,H)
    %
    % initialization of a MLR model
    %
    % input:
    % ------------------------------------------------------------------------------
    %   F: number of features
    %   H: number of classes (Hidden states in our case)
    % ------------------------------------------------------------------------------
    %
    %
    % output:
    % ------------------------------------------------------------------------------
    %  O: structure that contains all sepparating hyperplanes 
    %  for each class for logistic regression
    % ------------------------------------------------------------------------------
    %

    rng('default');
    if nargin==1
        F=obj.F;
        H=obj.Y;
    end

    for y_ = 1:H
        O.a{y_}=rand(F+1,1);
    end

end
