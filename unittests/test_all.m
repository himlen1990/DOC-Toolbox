clear;clc;
addpath('../DOC')
rng('default')

for f = dir('.')'; 
    if f.name(end)=='m'
        if strcmp(f.name,'test_all.m');continue;end
        if strcmp(f.name(1:4),'test')
            clc
            clear set
            clear data
            clear res 
            clear pre
            clear res
            disp(f.name)
            run(f.name)
        end
    end
end

disp('--tests done--')
