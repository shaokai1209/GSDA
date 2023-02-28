function B = solve_l1l2(W,num,fdim,lambda)
B = W;
%---------------------------
nWvector = sum(W.*W,2);
for i=1:num
    tmp = nWvector((i-1)*fdim+1:fdim*i);
    nW = sqrt(sum(tmp));
    nW_lambda = nW - lambda;
    if nW_lambda > 0
        B((i-1)*fdim+1:fdim*i,:) = W((i-1)*fdim+1:fdim*i,:)*(nW_lambda/nW);
    else
        B((i-1)*fdim+1:fdim*i,:) = zeros(fdim,size(B,2));
    end
end