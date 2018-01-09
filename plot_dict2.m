function [ ] = plot_dict2(dict, r_num, c_num, rows, cols, U)
% Input: 
%   dict: the learned dict 
%   r_num, c_num: rows and cols of every dict
%   rows, cols: rows and cols of subplots
%   U: PCA transform matrix
    
    % normalize
    [~, dict_num] = size(dict);
    figure(99);
    new_dict = U * dict;
    for cnt = 1:dict_num
        subplot(rows, cols, cnt);
        tmp = reshape(new_dict(:, cnt), [r_num, c_num]);
        imagesc(tmp);
        axis off;
        colormap jet;
        axis xy;
    end
    
end
