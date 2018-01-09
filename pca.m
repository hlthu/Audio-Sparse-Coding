function [U] = pca(X,K)
% Input: 
%   X: matrix with image patches as columns 
%   K: the number of largest magnitude eigenvalues
% Output: 
%   U: eigenvector matrix. Each column is an eigenvector 
    
    % normalize
    X = X';
    [m, n] = size(X);
    mu = mean(X);
    st = std(X);
    X = (X-repmat(mu,m,1))./repmat(st,m,1);
    
    % correlatoin
    C = corrcoef(X);
    
    % eig 
    [V, ~] = eig(C);
    V = rot90((V))';
    
    % return U
    U = V(:,1:K);
    
end
