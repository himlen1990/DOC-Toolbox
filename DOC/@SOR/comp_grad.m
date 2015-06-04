function grad = comp_grad(obj,X,y,O,node_potn,frac)
%————————————————————
% INFO:
% see ../@MLR/comp_grad.m for describtion
%————————————————————

    grad = packages.STRUCT.mult(O,0);

    grad.a = grad.a + sum(repmat(frac.a(y,:),obj.F,1).*X,2);
    grad.a = grad.a - sum(repmat(sum(node_potn.*frac.a,1),obj.F,1).*X,2);

    grad.sigma = grad.sigma + sum(frac.sigma(y,:),2);
    grad.sigma = grad.sigma - sum(sum(node_potn.*frac.sigma));

    grad.b1 = grad.b1 + sum(frac.b1(y,:),2);
    grad.b1 = grad.b1 - sum(sum(node_potn.*frac.b1));

    S = length(O.d)+2;
    for j=1:S-2,
        grad.d(j) = grad.d(j) + sum(frac.d{j}(y,:),2);
        grad.d(j) = grad.d(j) - sum(sum(node_potn.*frac.d{j}));
    end
end
