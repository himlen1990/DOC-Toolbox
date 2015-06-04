function [node_potn, frac] = comp_potn(obj,X,O)
%————————————————————
% INFO:
% see ../@MLR/comp_potn.m for describtion
%————————————————————


    S = length(O.d)+2;
    L = size(X,2);
    b = [-Inf; O.b1; O.b1 + cumsum(O.d.^2); +Inf];  % b = [b_0, b_1, ..., b_S]'


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   compute node potentials                         
    %                                                   [ Y X L ]
    %
    %
    f = O.a'*X;
    z1= (repmat(b(2:S+1),[1,L]) - repmat(f,[S,1])) / (O.sigma^2 + obj.small);
    z2= (repmat(b(1:S),[1,L]) - repmat(f,[S,1])) / (O.sigma^2 + obj.small);
    node_potn = normcdf(z1) - normcdf(z2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   compute gradients at position x
    %   Parts of the code were taken from the Conditional Ordinal 
    %   Random Fields project which can be downloaded here:
    %   http://seqam.rutgers.edu/
    %   
    %                                                 [ Y X L ]
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % z-statistics
    Npz1 = normpdf(z1);
    Npz2 = normpdf(z2);
    Ncz1 = normcdf(z1);
    Ncz2 = normcdf(z2);

    % Ds(x,y)/Da
    frac.a = ((Npz2-Npz1)./(Ncz1-Ncz2+obj.small)) / (O.sigma^2 + obj.small);

    % Ds(x,y)/Dsigma
    pz1 = z1.*Npz1;  pz1(S,:) = 0;  % Inf*0 -> 0
    pz2 = z2.*Npz2;  pz2(1,:) = 0;  % Inf*0 -> 0
    zdiff = pz2 - pz1;
    frac.sigma = (2*zdiff./(Ncz1-Ncz2+obj.small)) / (O.sigma + obj.small);

    % Ds(x,y)/Db1
    dz1b1 = ones(S,1)/(O.sigma^2 + obj.small); dz1b1(S) = 0; dz1b1 = repmat(dz1b1,[1,L]);
    dz2b1 = ones(S,1)/(O.sigma^2 + obj.small); dz2b1(1) = 0; dz2b1 = repmat(dz2b1,[1,L]);
    frac.b1 = (dz1b1.*Npz1-dz2b1.*Npz2)./(Ncz1-Ncz2+obj.small);

    % Ds(x,y)/Dd
    for j=1:S-2,
        dz1d{j} = ones(S,1); 
        dz1d{j}([1:j,S]) = 0; dz1d{j}([j+1:S-1]) = 2*O.d(j)/(O.sigma^2 + obj.small);
        dz1d{j} = repmat(dz1d{j},[1,L]);

        dz2d{j} = ones(S,1); 
        dz2d{j}([1:j+1]) = 0; dz2d{j}([j+2:S]) = 2*O.d(j)/(O.sigma^2 + obj.small);
        dz2d{j} = repmat(dz2d{j},[1,L]);

        frac.d{j} = (dz1d{j}.*Npz1-dz2d{j}.*Npz2)./(Ncz1-Ncz2 + obj.small);
    end
end
