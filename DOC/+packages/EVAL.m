function res = EVAL(te,pre)

    assert(length(te)==length(pre));

    gt_y = {};
    pr_y = {};
    gt_h = {};
    pr_h = {};
    if isfield(te{1},'Y')
        for i = 1:length(te)
            gt_y{i} = te{i}.Y;
            pr_y{i} = pre{i}.Y';
        end
        gt_y = cell2mat(gt_y);
        pr_y = cell2mat(pr_y);

        [res_y, y_hat]= get_metrics(pr_y, gt_y);
        res.Y = res_y;
    end

    % compute marginal node posterioris
    if isfield(te{1},'H')
        for i = 1:length(te)
            tmp = zeros(size(pre{i}.H{1}));
            for j = 1:length(pre{i}.H)
                tmp = tmp + pre{i}.H{j}*pre{i}.Y(j);
            end
            pr_h{i}=tmp;
            gt_h{i}=te{i}.H;
        end

        pr_h = cell2mat(pr_h);
        gt_h = cell2mat(gt_h);

        [res_h, h_hat]= get_metrics(pr_h, gt_h);
        res.H = res_h;
    end

end

function [res y_hat] = get_metrics(pr,gt)

    if size(pr,1)<2
        y_hat = 'computation not possible';
        res = 'computation not possible';
        return
    end

    [~, y_hat] = max(pr);


    % compute F1
    for i = unique(gt)
        TP = sum( (gt==i) .* (y_hat==i) );
        FP = sum( (gt~=i) .* (y_hat==i) );
        FN = sum( (gt==i) .* (y_hat~=i) );
        TN = sum( (gt~=i) .* (y_hat~=i) );
        f1{i} = 2*TP/(2*TP+FP+FN);
        acc{i} = (TP+TN)/(TP+FP+TN+FN);
    end
    res.f1 = f1;
    res.acc = acc;
    res.F1 = mean([f1{:}]);
    res.ACC = mean([acc{:}]);



    % compute pearson correlation coefficients
    % 1) pearson covariance
    res.PCC = mean((y_hat - mean(y_hat)) .* (gt - mean(gt))) ./ (std(y_hat)*std(gt));

    % 2) icc 
    res.ICC = packages.ICC(2,'single',[y_hat;gt]');

    % mean absolute error
    res.MAE = mean(abs(gt-y_hat));

    % root mean square error 
    res.RMS = mean((gt-y_hat).^2);

    % compute confusion matrix 
    y_hat_ = num2cell( num2str(y_hat) );
    gt_ = num2cell( num2str(gt) );
    res.CM = confusionmat(gt_,y_hat_);

end
