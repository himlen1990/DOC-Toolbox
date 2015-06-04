classdef HCORF < SOR
%————————————————————
% INFO:
% see ../@MLR/MLR for description
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
        Ho = 3;
        % default number of odinal states is 0
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
