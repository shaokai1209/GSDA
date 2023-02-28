function [U,V,obj]=gssnmf(X,D,para,A,S)
% X in d \times N
%JIA_YUHENG Semi-Supervised Non-Negative Matrix Factorization With Dissimilarity and Similarity Regularization
%%%-------------------------------------------------------------------------------
%%%input:
%   X = [Xl,Xu]：
%   Xl is labled,and Xu is unlabled X(d,n)
%   D is a Matrix based on lable information
%   para is parameter,which includ :
%       maxiter:
%       K: number of hidden factors
%       mu: Similarity coefficient
%       lambda: Coefficient of dissimilarity
%   A(n*n) is a diagonal matrix with its diagonal element   
%    A（i，i）= sum(S(i,j)) 第J列和
%猜测： S是对角矩阵 左上角为s1为标签构造的相似性矩阵，右下角为s2，为构造的亲和矩阵

%   W：
%       2.w就是S
%%%output:
%       U 基矩阵
%       V 编码矩阵
%       obj目标函数
%图的半监督非负矩阵分解



lambda=para.lambda;  % the hyper papramter lambda
%不相似性系数
k=para.k;
maxiter=para.maxiter;
mu=para.mu;%相似性系数

d=size(X,1);
n=size(X,2);


L=A-S;

% init 初始化
U=rand(d,k);
V=rand(k,n);
V1 = EuDist2(V');
%  obj(1)=sum(sum((X-U*V).^2))+lambda*sum(sum((D.*(V'*V)).^2))+mu*trace(V*L*V');
obj(1)=sum(sum((X-U*V).^2))+lambda*sum(sum((D.*(V'*V)).^2))+mu*norm((S.*V1),1);
for iter=1:maxiter
    U=U.*((X*V')./(U*V*V'+eps));
    V=V.*((U'*X+mu*V*S)./(U'*U*V+lambda*V*D+mu*V*A+eps));
    Z=X-U*V;

    % normization
    V=V.*(repmat(sum(U,1)',1,n));
    U=U./(repmat(sum(U,1),d,1));
    obj(iter+1)=sum(sum(Z).^2)+lambda*sum(sum((D.*(V'*V)).^2))+mu*norm((S.*V1),1);
%    obj(iter+1)=sum(sum(Z).^2)+lambda*sum(sum((D.*(V'*V)).^2))+mu*trace(V*L*V');
%     disp(['the ', num2str(iter), ' obj is ', num2str(obj(iter))]);
    if (abs(obj(iter+1)-obj(iter))<10^-3)
        break;
    end
end