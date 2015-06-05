cd 'DOC/+inference/'

    ls
    switch computer
        case 'GLNXA64'
            mex crfChain_inferC_GLNXA64.c
            movefile('crfChain_inferC_GLNXA64.mexa64','crfChain_inferC.mexa64','f')

        case 'MACI64'
            mex crfChain_inferC_GLNXA64.c
            movefile('crfChain_inferC_GLNXA64.mexmaci64','crfChain_inferC.mexmaci64','f')

        case 'PCWIN64'
            mex crfChain_inferC_PCWIN64.c
            movefile('crfChain_inferC_PCWIN64.mexw64','crfChain_inferC.mexw64','f')
    end

cd '../..'
