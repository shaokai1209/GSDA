function [ P1,obj] = GSDA(X,para,Xt,Y)
gamma=para.gamma;  % the hyper papramter lambda
%不相似性系数
k=para.k;
mu=para.mu;%相似性系数
beta = para.beta;
maxiter = para.maxiter;
dim = para.dim;
alpha=para.alpha;
for i = 1 : 10
    [P,obj]=myGSDA(X,para,Xt,Y);
    d=size(X,1);
    n=size(X,2);
    [tn,td] = size(Xt);
    Xs = X(:,1:n-tn);
    Xt = X(:,n-tn+1:end);
    Zs = P'*Xs;
    Zs = Zs*diag(sparse(1./sqrt(sum(Zs.^2))));
    Zt = P'*Xt;
    Zt = Zt*diag(sparse(1./sqrt(sum(Zt.^2))));
    Ys = Y(1:n-tn,:);
    Yt = Y(n-tn+1:end,:);
    model= svmtrain(Ys,Zs','-s 0 -t 0 -c 1 -g 1 ');
    [ Y_tar_pseudo, acc,~] = svmpredict(Yt,Zt',model);
%     disp("train Acc");
%     disp(acc(1));
    Y = [Ys;Y_tar_pseudo];
P1 = P;
end

end


function [P,obj]=myGSDA(X,para,Xt,Y)
gamma=para.gamma;  % the hyper papramter lambda
%不相似性系数
k=para.k;
mu=para.mu;%相似性系数
beta = para.beta;
maxiter = para.maxiter;
dim = para.dim;
alpha=para.alpha;
d=size(X,1);
n=size(X,2);
[tn,td] = size(Xt);
Xs = X(:,1:n-tn);
Xt = X(:,n-tn+1:end);
Ys = Y(1:n-tn,:);
Yt = Y(n-tn+1:end,:);
% init 初始化
Options = [];
Options.ReducedDim =100;
P=PCA1(X',Options);
v=sqrt(sum(P.*P,2));
G = diag(0.5./(v));
D = constructD(Y,para);
H = eye(n)-1/(n)*ones(n,n);
[A,S] = constructS((P'*Xt)',Ys,para);
LS = A-S;
[A1,D] = constructD(Y,para);
LD = A1-D;
I = eye(d);
for iter=1:maxiter
    obj(1)=0;
      % ***********  Update P
    [P,~] = eigs(-(X*X')+(alpha*X*LS*X'-beta*X*LD*X')+gamma*G,I,dim,'SM');%X*H*X'
    % ***********Update G
    G = diag(sparse(1./(sqrt(sum(P.^2,2)+eps))));
    
    temp1 = trace(P'*X*X'*P);
    temp2 = trace(P'*X*(alpha*LS-beta*LD)*X'*P);
    temp3 = gamma*trace(P'*G*P);
    obj(iter+1)=temp1+temp2+temp3;
    if (abs(obj(iter+1)-obj(iter))<10^-2)
        break;
    end
end
end
