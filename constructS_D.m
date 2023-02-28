%构建da相似性与非相似性矩阵
%利用源域的标签信息构建不相似性矩阵D
%--------------------------------------------------
%24-29行，实现相似性信息时采用相加法
%-------------------------------------------------
%d(i,j)= 1; if xi,xj∈ Xl and xi,xj∈ different classes
%d(i,j) = 0 ;others
%L is 目标值，通常是length of X_lable,X_L[X_S_L,X_T_L]
function DS = constructS_D(Xs_lable,X,para)

L = para.num;
alfa = para.alfa;
lambda=para.lambda;
%构建相似性矩阵S非相似性矩阵D
%
S = constructS(Xs_lable,L);
D = constructD(Xs_lable,L);
options = [];
options.NeighborMode = 'KNN';
options.k = para.K;
options.WeightMode = 'Binary';
W = constructW(X,options);
W = full(W)+S;%无监督的KNN构成的0-1 + 标签相似度矩阵s
[r,c]= size (W);
for i= 1:r
    for j = 1:c
        if W(i,j)== 2
            W(i,j) = 1;
        end
    end
    
end


DS =lambda*W +alfa*D;%ds既有相似性信息也有非相似
end





function [D] = constructD(Xs_lable,L)

Xs_length = length(Xs_lable);
D_S = zeros(Xs_length,Xs_length);%根据标签长度创造一个1矩阵的方阵
for i = 1:Xs_length
    for j = 1: Xs_length
        if Xs_lable(i) ~=Xs_lable(j)
            D_S(i,j)=1;
        end
            
    end    
    
end 
% d = [D_S, zeros(Xs_length,L - Xs_length)];%补零将横坐标补全到目标值
% D = [d; zeros(L - Xs_length,L)];%将纵坐标补全到目标值

D = blkdiag(D_S,zeros(L - Xs_length,L - Xs_length));%将D_s矩阵与一个零矩阵按对角线放好

end
%利用源域的标签信息构建相似性矩阵s
%S相似性矩阵包含两个部分：
%s1 利用源域的标签构造矩阵
%s(i,j)= 1; if xi,xj∈ Xs and xi,xj∈ same classes
%s(i,j) = 0 ;others
%s2 利用核函数构造亲和矩阵
%L为总的标签数
%alfa 是系数用来控制s1相似性矩阵，S2非相似性矩阵的关系
function [s] = constructS(Xs_lable,L)
%初始化L = para.L;
Xs_length = length(Xs_lable);
s1 = zeros(Xs_length,Xs_length);%根据标签长度创造一个1矩阵的方阵
%定义临时变量用于调用constructW

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
s= blkdiag(s1,zeros(L - Xs_length,L - Xs_length));
% S2 = blkdiag(s2,zeros(L - length(s2),L - length(s2)));         
% s = S1-alfa*S2;%让s1,s2呈对角排列
% % s= blkdiag(s1,s2);

end





