function [] = PRINT(eval, path)

    hold off
    auc = eval.Y.AUC;
    x = eval.Y.AUC_coordinates.x;
    y = eval.Y.AUC_coordinates.y;
    for i = 1:length(auc)
        plot(x{i},y{i})
        name{i}=['Class: ',num2str(i),'     AUC: ',num2str(auc(i))];
        hold all
    end
    fig = gcf;
    legend(name);
    xlabel('False positive rate'); 
    ylabel('True positive rate')
    title(['ROC for multiclass classification:   ', num2str(mean(auc))])

    X_size = 8;
    Y_size = 6;

    set(fig, 'PaperSize', [X_size Y_size]);
    set(fig, 'PaperPositionMode', 'manual');
    set(fig, 'PaperPosition', [0 0 X_size Y_size]);

    set(fig, 'PaperUnits', 'inches');
    set(fig, 'PaperSize', [X_size Y_size]);
    set(fig, 'PaperPositionMode', 'manual');
    set(fig, 'PaperPosition', [0 0 X_size Y_size]);

    set(fig, 'renderer', 'painters');
    print(fig, '-dpdf', path)
end
