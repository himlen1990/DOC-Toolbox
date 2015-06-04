classdef VSL_CRF < HCORF & HCRF
%————————————————————
% INFO:
% see ../@MLR/MLR.m for description
%————————————————————


    properties

        v=[];
        init = 0;
        Type;
        Class;

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
