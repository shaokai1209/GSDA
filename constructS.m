%利用源域的标签信息构建相似性矩阵s
%S相似性矩阵包含两个部分：
%s1 利用源域的标签构造矩阵
%s(i,j)= 1; if xi,xj∈ Xs and xi,xj∈ same classes
%s(i,j) = 0 ;others
%s2 利用核函数构造亲和矩阵
%L为总的标签数
%alfa 是系数用来控制s1相似性矩阵，S2非相似性矩阵的关系
function [A,S] = constructS(Xt,Xs_lable,para)
%初始化L = para.L;

L = para.num;
Xs_length = length(Xs_lable);
s1 = zeros(Xs_length,Xs_length);%根据标签长度创造一个0矩阵的方阵
%constructW 非标记信息构造W
options = [];
options.NeighborMode = 'KNN';
options.k =5;
options.WeightMode = 'Binary';
W = constructW(Xt,options);
%构造S1
for i = 1:Xs_length
    for j = 1: Xs_length
        if Xs_lable(i) == Xs_lable(j)
            s1(i,j)=1;
        end      
    end        
end
%构造S,s1= [s1,0;0,0],S2 = [SU,0;0,0]
%如果想令S2为空，传入0矩阵即可
S = blkdiag(s1,W);
% s= blkdiag(s1,zeros(L - Xs_length,L - Xs_length));

% S2 = blkdiag(s2,zeros(L - length(s2),L - length(s2)));         
% s = S1-alfa*S2;%让s1,s2呈对角排列
% % s= blkdiag(s1,s2);
A = diagS (S);
end

function A = diagS (S)
%构造相似性信息的对角矩阵
    [mFea,nSmp]=size(S);
    DCol = full(sum(S,2));
   A = spdiags(DCol,0,nSmp,nSmp);
end
