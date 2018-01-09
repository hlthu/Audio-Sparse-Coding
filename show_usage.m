function [A_sort, us_sort] = show_usage(A, lca_iters, tau_rate, L_norm, lamda)
%% compute the usage of every dict
    
    [~, dict_size] = size(A);
    pca_list = dir('pca/*_*.mat');
    us = zeros(dict_size, 1);

    for cnt = 1:length(pca_list)
        file_name = strcat(pca_list(cnt).folder, '/', pca_list(cnt).name);
        load(file_name);
        y_t = PCA_Segs;
        [~, batch_size] = size(y_t);
        u_t = zeros(dict_size, batch_size);  % internal variable u_t
        G = A' * A - eye(dict_size);         % A^T*A-I
        b_t = A' * y_t;                      % b_t        
        for j = 1:lca_iters
            if L_norm == 'L0'
                s_t = u_t .* (abs(u_t) > lamda);
            else
                s_t = (u_t - sign(u_t) * lamda) .* (abs(u_t) > lamda);
            end
            u_t = u_t + tau_rate * (b_t - u_t - G*s_t);
        end
        if L_norm == 'L0'
            s_t = u_t .* (abs(u_t) > lamda);
        else
            s_t = (u_t - sign(u_t) * lamda) .* (abs(u_t) > lamda);
        end
        % accumulate
        us = us + sum(abs(s_t), 2);
    end
    
    %% sort
    [us_sort, ix] = sort(us);
    ix = ix';
    A_sort = A(:,ix);

    figure(); plot(us_sort);

end
