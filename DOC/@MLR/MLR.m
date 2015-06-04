classdef MLR < seq_classify 
    %
    % MLR Base Class 
    %
    % info:
    % ------------------------------------------------------------------------------
    % this class is used to define the MLR object with its function 'train'
    % and 'predict'.
    % ------------------------------------------------------------------------------

    properties

        Ln = 0;
        % default regularization is 0


    end

    methods 

        function out = train(obj,train_data)
            out = train@seq_classify(obj,train_data);
        end

        function out = predict(obj,O, data)
            out = predict@seq_classify(obj,O,data);
        end

    end

end
