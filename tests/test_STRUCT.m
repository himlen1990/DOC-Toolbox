load('test_STRUCT')
model_1.H2D{1,4}=4;
model_1.H2D{3,4}=4;

cellsOfStructs ={};
for i = 1:10
    model_1.rand=rand(10);
    model_1.u_n{1}=rand(3);
    cellsOfStructs{end+1}=model_1;
end
model_10 = packages.STRUCT.sum(cellsOfStructs);

assert(all(all(model_1.rand<model_10.rand)))

res{1} = packages.STRUCT.mult(model_10, 2);
res{2} = packages.STRUCT.mult(model_10,-2);
res = packages.STRUCT.sum(res);
assert(all(all(res.rand==0)))
