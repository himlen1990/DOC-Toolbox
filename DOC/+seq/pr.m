function out = pr(te,mod)
    % compute different measures using the trained model
    if ~isempty(mod.PREPROCESS)
        pp_data = packages.PREPROCESS(te,mod.PREPROCESS);
        te = pp_data.data;
    end

    switch mod.meth

        case 'MLR'
            m = MLR;
        case 'SOR'
            m = SOR;
        case 'CRF'
            % set all seq labels to 1
            for i = 1:length(te)te{i}.Y = 1;end
            m = HCRF;
        case 'CORF'
            % set all seq labels to 1
            for i = 1:length(te)te{i}.Y = 1;end
            m = HCORF;
        case 'HCRF'
            m = HCRF;
        case 'HCORF'
            m = HCORF;
        case 'VSL_CRF'
            m = VSL_CRF;
    end

    out = m.predict(mod,te);

end
