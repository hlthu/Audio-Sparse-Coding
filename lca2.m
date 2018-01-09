function [A_new] = lca2(A, y_t, lca_iters, tau_rate, learning_rate, L_norm, lamda, theta)
%% do LCA and dict learning
% Copyright Wei Song
    
    [~, dict_size] = size(A);
		[~, batch_size] = size(y_t);
    u_t = zeros(dict_size, batch_size);  % internal variable u_t
    G = A' * A - eye(dict_size);        % A^T*A-I
    b_t = A' * y_t;                     % b_t
    
    for j = 1:lca_iters
        if L_norm == 'L0'
            s_t = u_t .* (abs(u_t) > lamda);
        else
            s_t = (u_t - sign(u_t) * lamda) .* (abs(u_t) > lamda);
        end
        % u_t = u_t + tau_rate * (b_t - u_t - G*s_t);
        u_t = u_t + tau_rate * (b_t - u_t - G*s_t);
    end
	if L_norm == 'L0'
        s_t = u_t .* (abs(u_t) > lamda);
    else
        s_t = (u_t - sign(u_t) * lamda) .* (abs(u_t) > lamda);
    end
		
    A = A + learning_rate * (y_t - A * s_t) * s_t' + theta * (A - A*A'*A);
    A_new = A * diag(1./sqrt(sum(A.^2)));   % norm

end
