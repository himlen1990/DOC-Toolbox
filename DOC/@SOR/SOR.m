classdef SOR < seq_classify 
    %
    % MOR Base Class 
    %
    % info:
    % ------------------------------------------------------------------------------
    % this class is used to define the MOR object with its function 'train'
    % and 'predict'.
    % ------------------------------------------------------------------------------

    properties

        Lo = 0;

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
