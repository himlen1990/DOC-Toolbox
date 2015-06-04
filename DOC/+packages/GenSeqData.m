classdef GenSeqData
    properties

        C =   3%   N Clases
        H =   4%   N Intensities
        F =   2%   dim of feature space
        L =   1%   average sequence length


        % Optional Settings 
        Transition_Factor = 3           % less transitions with higher value
        Latent_State_Distance = 6% latent state have larger distance in feature space
        Latens_State_Distribution = 10% latent state have larger distance in feature space
        Class_Distribuition = 10        % Distance between classis in feature space


    end
    methods
        function obj = GenSeqData()
            rng('default');
        end
        function out = generate( obj, N )
            % Length (1xN array)
            L = int16(abs(normrnd(obj.L,obj.L/5,1,N)-10)+10);

            % Classes (1xN array)
            C = randi(obj.C,1,N);

            % Transition Matrix
            for i = 1:obj.H
                for j = 1:obj.H
                    T_ord(i,j)=(obj.H-abs(i-j))^obj.Transition_Factor;
                end
            end
            U = T_ord./repmat(sum(T_ord,2),1,obj.H);

            % generate ordinal seeds for each class
            for i = 1:obj.C
                P = ones(1,obj.F)-(2*rand(1,obj.F));
                S = ones(1,obj.H)*obj.Latent_State_Distance;
                X{i}{1} = rand(1,obj.F)*obj.Class_Distribuition;
                for  j = 2:obj.H
                    X{i}{j}=X{i}{j-1}+(P*S(j));
                end
            end

            out={};
            for i = 1:N
                tmp.Y= C(i);

                % use transition matrix to generate intensities
                tmp.H= zeros(1,L(i));
                tmp.H(1) = randi(obj.H);
                for l = 2:L(i);
                    Tr_Prob = U(tmp.H(l-1),:);
                    tmp.H(l)  = sum(rand >= cumsum(Tr_Prob))+1;
                end

                tmp.X= zeros(obj.F,L(i));
                for j = 1:obj.H
                    K = tmp.X(:,tmp.H==j);
                    offset = repmat(X{C(i)}{j}',1,size(K,2));
                    value = rand(size(K));
                    tmp.X(:,tmp.H==j)=(normrnd(value,obj.Latens_State_Distribution))+offset;
                end

                out{end+1}=tmp;

            end
        end
        function [] = plot(obj, data)
            stp = double(100/(obj.H)-1);
            stp = stp:stp:100;
            stp = stp./100;
            col{1} = zeros(3,length(stp));
            col{2} = zeros(3,length(stp));
            col{3} = zeros(3,length(stp));
            col{1}(1,:)=stp;
            col{2}(2,:)=stp;
            col{3}(3,:)=stp;

            C=[];
            H=[];
            X=[];
            for i = 1:length(data)
                for j = 1:length(data{i}.X)
                    c = data{i}.Y;
                    h = data{i}.H(j);
                    X = [X data{i}.X(:,j)];
                    H = [H h];
                    C = [C; col{c}(:,h)'];
                end
            end
            scatter(X(1,:),X(2,:),25,C,'filled')
        end
        function out = test_data(obj)
            % linear separable date
            obj.Transition_Factor = 3;
            obj.Latent_State_Distance = 2;
            obj.Latens_State_Distribution = 1;
            obj.Class_Distribuition = 75;
            tmp = obj.generate(40);
            out.S.tr = tmp(1:20);
            out.S.te = tmp(21:end);


            % not linear separable date
            obj.Transition_Factor = 3;
            obj.Latent_State_Distance = 6;
            obj.Latens_State_Distribution = 10;
            obj.Class_Distribuition = 10;
            tmp = obj.generate(40);
            out.N.tr = tmp(1:20);
            out.N.te = tmp(21:end);

            % indistinguishable data 
            obj.Transition_Factor = 1;
            obj.Latent_State_Distance = 0;
            obj.Latens_State_Distribution = 1;
            obj.Class_Distribuition = 0;
            tmp = obj.generate(40);
            out.I.tr = tmp(1:20);
            out.I.te = tmp(21:end);

        end
    end
end
