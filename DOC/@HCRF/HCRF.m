classdef HCRF < MLR
%————————————————————
% INFO:
% see ../@MLR/MLR.m for description
%————————————————————
    %
    % Base Class initial model
    %
    % info:
    % ------------------------------------------------------------------------------
    % this class is used to define the base object with its function 'train'
    % and 'predict'.
    % ------------------------------------------------------------------------------

    properties
        Hn = 3;
        % default number of nominal hidden states is 3
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
