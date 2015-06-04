classdef seq_classify 

    properties (Access = public)
        %
        % public class properties that can be accesed and changed
        % outside the class
        %
        iter= 100;          % number of iterations
        display ='iter'     % optimization display setting
        DEBUG = 0;          % debug mode (only one iteration on one sequence)
        GRAD = 'on';        % optimization gradient setting
        H_OBS = 0;          % unobserved latent states 
        PARALLEL = 0;       % apply parallel processiong of all sequenes
        meth;
        PREPROCESS;         % parameters for preprocessing (PCA, Normalization...)
        O_init;             % input model
        O_out;              % output model
        ncll;               % resulting score
        other;              % temporary structure for all other values
    end

    properties (Access = protected)
        %
        % protected class properties that can not be accesed and changed
        % outside the class
        %
        small = 1e-12;      % realmin
        big= 1e12;      % realmin
        Y;                  % N-Classes
        F;                  % N-Features
    end


    methods  (Access = public)
        function obj = train(obj, data)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %                                                               
            %   -- Train model --                                          
            %   initialize model parameter and applies gradien
            %   decent on the objective function
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % initial class properties
            obj = obj.init_para(data);

            % initial model proberties
            obj.O_init = obj.init_model();

            % setting for optimization algorithm
            settings = optimset(  ...
                'Display', obj.display, ...
                'Diagnostics', 'off', ...
                'LargeScale','off', ...
                'Gradobj', obj.GRAD, ...
                'MaxIter', obj.iter, ...
                'MaxFunEval', 5000,...
                'TolX',1e-6 ...
                );


            if obj.DEBUG==1
                [ncll grad] = obj.RLL(obj.O_init,data);
                out = obj.O_init;
                obj.O_out=obj.O_init;
            else
                if obj.iter~=0
                    out = packages.FMINUNC(@obj.RLL,obj.O_init,settings,data);
                else
                    out = obj.O_init;
                end
                [ncll ~] = obj.RLL(out,data);
                obj.ncll= ncll;
            end

            % final iteration and save object settings
            [~,~,obj] = obj.RLL(out,data);

            % return the resulting model
            obj.O_out = out;
        end


        function [ncll,grad,obj] = RLL(obj,O,data)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %                                                               
            %   -- Objective Function --                                          
            %   returns the negative-log-likelihood 'ncll' and gradients 
            %   'grad' of the current model parameters 'O' on the data 
            %   'data'
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            L = 1:length(data);

            % loop over the first sequence only if in debug mode
            if obj.DEBUG==1; L = 1; end

            for i = L
                % remove latent state labels if 
                % the unobserved flag is set
                if obj.H_OBS==0
                    data{i}.H=[];

                % check if data contains latent state labels 
                else
                    try
                        data{i}.H;
                    catch error
                        data{i}.H=[];
                    end
                end
            end


            for i=L
                try
                    Y{i}=data{i}.Y;
                catch error
                    Y{i}=1;
                end
                X{i}=data{i}.X;
                H{i}=data{i}.H;
            end

            if obj.PARALLEL==1
                parfor i=L
                    [cll{i}, grad_seq{i}, other{i}] = obj.objective(Y{i},H{i},X{i},O,i);
                end
            else
                for i=L
                    [cll{i}, grad_seq{i}, other{i}] = obj.objective(Y{i},H{i},X{i},O,i);
                end
            end

            % regularization cost and gradient 
            [reg_cost, grad{1}, other] = obj.regul(O,other);     

            % negative conditional log likelyhood of all sequences
            cll = sum([cll{:}]);

            ncll = -cll;
            %ncll



            % grandent of the conditional log likelihood of all sequences
            grad_seq = packages.STRUCT.sum(grad_seq);

            % grandent of the negative conditional log likelihood of all sequences
            grad{2} = packages.STRUCT.mult(grad_seq,-1);

            % add gradients of regularization term
            grad = packages.STRUCT.sum(grad);

            % add negative conditional log likelihood or regularization term
            ncll = ncll + reg_cost;
            obj.other=other;
        end
    end

    methods(Static)
        function out = predict(obj, mod, data)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %                                                               
            %   -- Prediction Function --                                          
            %   returns the likelihood of each class and each latent state
            %   on the data 'data', using the model 'mod'
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            L = 1:length(data);

            % loop over the first sequence only if in debug mode
            if mod.DEBUG==1;L = 1;end

            for i=L

                X=data{i}.X;
                for y_ = 1:mod.Y
                    [p(y_), cll{y_}, ~, node_post, edge_post] = mod.objective(y_,[],X, mod.O_out,i);
                end

                % save results
                out{i}.Y = exp(p)/sum(exp(p));
                out{i}.H = node_post;
            end
        end
    end
end
