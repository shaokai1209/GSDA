%利用源域的标签信息构建不相似性矩阵D
%d(i,j)= 1; if xi,xj∈ Xl and xi,xj∈ different classes
%d(i,j) = 0 ;others
%L is 目标值，通常是length of X_lable,X_L[X_S_L,X_T_L]
function [A1,D] = constructD(Xs_lable,para)
L = para.num;
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
A1 = diagS (D);
end

function A1 = diagS (D)
%构造相似性信息的对角矩阵
    [mFea,nSmp]=size(D);
    DCol = full(sum(D,2));
   A1 = spdiags(DCol,0,nSmp,nSmp);
end


