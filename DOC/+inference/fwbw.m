function [node_post edge_post logZ] =fwbw(node_potn, edge_potn)

    % use C++ implemenatation of forward/backward algorithm
    [node_post edge_post logZ] = inference.crfChain_inferC(node_potn',edge_potn);

    % use Matlab implemenatation of forward/backward algorithm
    %[node_post edge_post logZ] = inference.crfChain_inferM(node_potn',edge_potn);


    node_post = node_post';

end
