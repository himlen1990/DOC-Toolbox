function data = READ_TRACKER(in_path)

    txt_files = {};
    tmp = {};
    files = dir([in_path,'*.txt']);

    for file = files'
        if length(file.name)<4;continue;end
        txt_files{end+1}=[in_path,file.name];
        tmp{end+1} = file.name(end-5:end);
    end

    [~,pos] = sort(tmp);
    txt_files = txt_files(pos);

    txt_files = sort(txt_files);
    Landmarks = {};
    FrameID = {}
    for i = 1:length(txt_files)
        file = txt_files{i};
        fileID = fopen(file,'r');
        tmp = fscanf(fileID,'%f');
        tmp = tmp(24:end)';
        X = tmp(1:2:end);
        Y = tmp(2:2:end);
        if any(X == -1)
            continue
        end
        if any(Y == -1)
            continue
        end
        FrameID{end+1} = i;
        Landmarks{end+1} = [X;Y]';
        fclose(fileID);
    end
    data{1}.Landmarks = Landmarks;
    data{1}.FrameID = FrameID;

end
