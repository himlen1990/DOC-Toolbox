function mod = tr(meth,tr,l,set)
    % model training

    if nargin>3
        if isfield(set,'raw_landmarks')
            if set.raw_landmarks
                % compute features using landmarks from training set
                pp_data = packages.PREPROCESS(tr);
                tr = pp_data.data;
            end
        end
    end
    

    switch meth

        case 'MLR'
            m = MLR;
            m.Ln=l(1);
        case 'SOR'
            m = SOR;
            m.Lo=l(1);
        case 'CRF'
            m = HCRF;
            % set all seq labels to 1
            for i = 1:length(tr)tr{i}.Y = 1;end
            set.observed_h = 1;
            m.Ln=l(1);
        case 'CORF'
            m = HCORF;
            % set all seq labels to 1
            for i = 1:length(tr)tr{i}.Y = 1;end
            set.observed_h = 1;
            m.Lo=l(1);
        case 'HCRF'
            m = HCRF;
            m.Ln=l(1);
        case 'HCORF'
            m = HCORF;
            m.Lo=l(1);
        case 'VSL_CRF'
            m = VSL_CRF;
            m.Ln=l(1);
            m.Lo=l(2);
            m.init = 1;
            m.iter = 10;
            mod = m.train(tr);
            m.O_init = mod.O_out;
            m.init = 0;
    end

    if nargin>3
        if isfield(set,'parallel')
            m.PARALLEL=set.parallel;
        end
        if isfield(set,'iter')
            m.iter = set.iter;
        end
        if isfield(set,'observed_h')
            m.H_OBS = set.observed_h;
        end
    end

    mod = m.train(tr);

    if nargin>3
        if isfield(set,'raw_landmarks')
            if set.raw_landmarks
                % save parameter for preprocessing in the model structure
                mod.PREPROCESS = pp_data.para;
            end
        end
    end
    mod.meth = meth;

end
