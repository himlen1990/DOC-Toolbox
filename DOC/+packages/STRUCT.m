classdef STRUCT

    methods (Static = true)

        function out = sum(cellofcells)
            if isstruct(cellofcells{1})
                out = subsum(cellofcells);
            else
                for i_ = 1:length(cellofcells)
                    for j_=1:length(cellofcells{1})
                        tmp{j_}{i_}=cellofcells{i_}{j_};
                    end
                end
                for i_ = 1:length(tmp)
                    out{i_} = subsum(tmp{i_});
                end
            end


            function out = subsum(cellOfCells)
                out = 1;
                names = fieldnames(cellOfCells{1})';

                %intial values
                for i = 1:length(names)
                    data{i} = getfield(cellOfCells{1}, char(names(i)));
                end

                for i = 2:length(cellOfCells)
                    for n = 1:length(names)
                        V = getfield(cellOfCells{i}, char(names(n)));
                        if iscell(V)
                            for j = 1:size(V,1)
                                for k = 1:size(V,2)
                                    data{n}{j,k}(:) = data{n}{j,k}(:)+V{j,k}(:);
                                end
                            end
                        else
                            data{n}(:) = data{n}(:)+V(:);
                        end

                    end
                end
                out = cell2struct(data,names,2);
            end

        end

        function out = mult(cell,factor)
            if isstruct(cell)
                out = submult(cell,factor);
            else
                for i_ = 1:length(cell)
                    out{i_} = submult(cell{i_},factor);
                end
            end

            function out2 = submult(cell,factor)
                Names = fieldnames(cell)';
                for i = 1:length(Names)
                    n = Names(i);
                    V = getfield(cell, char(n));
                    if iscell(V)
                        for j = 1:size(V,1)
                            for k = 1:size(V,2)
                                V{j,k} = V{j,k}*factor;
                            end
                        end
                    else
                        V = V * factor;
                    end
                    data{i}=V;
                    name{i}=n{1};
                end
                out2 = cell2struct(data,name,2);
            end

        end


    end
end
