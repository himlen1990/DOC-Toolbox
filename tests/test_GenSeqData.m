rng('default')
Seq = packages.GenSeqData;
data = Seq.generate(500);

assert(data{5}.Y==2);
assert(data{10}.Y==1);
assert(data{20}.Y==3);
assert(data{30}.Y==3);
