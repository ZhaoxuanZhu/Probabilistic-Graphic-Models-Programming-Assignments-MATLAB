clc
clear
close all

A.var = [3,2,1];
A.card = [2,2,2];
A.val = [0.5,0.8,0.3,0.1,0.8,0.4,0.2,0.5];

B.var = [2,3];
B.card = [2,2];
B.val = [0.3,0.4,0.1,0.8];

C = FactorProduct(A,B)
D = FactorMarginalization(A,2)
E = ObserveEvidence(A,[3,2;2,1])