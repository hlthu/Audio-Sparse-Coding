% close all; clear all; clc;
stage = 3;

%% some configs for Spectrograms
Num_Freq = 256;                           % number of frequencies
Freq_Sample = 16000;                      % Sample rate
Spec_Window = Freq_Sample * 20 / 1000;    % length of window for Spec, 15ms
Spec_Overlap = Freq_Sample * 12 / 1000;   % overlap of window for Spec, 12ms
Spec_Low_Freq = 100;
Spec_High_Freq = 4000;
Spec_Save_Path = 'spec';

%% some configs about timit set
Data_Dir = 'data';

%% Segmentation
Segs_Num = 26;		% means 25*(20-12)+20 = 220 ms
Segs_Overlap = Segs_Num / 2;
Segs_Save_Path = 'segs/';
if ~exist(Segs_Save_Path)
  mkdir(Segs_Save_Path);
end

%% The input to PCA Transform
% only using dev and test set
PCA_Num = 0;


%% stage 1
% generate spectrograms and segmentations
if stage <= 1
  M = [];

  f = 0:1/(Num_Freq-1):1;         % linear Freq
  % figure; plot(f)
  f = 10.^f;                     % turn it to log
  f = (f - 1)/(10 - 1);
  f = f * (Spec_High_Freq - Spec_Low_Freq) + Spec_Low_Freq;
  % now f is log in Spec_Low ~ Spec_High
  % figure; plot(f)
  if ~exist(Spec_Save_Path)
    mkdir(Spec_Save_Path);
  end
  
  % train data
  train_data_dir = strcat(Data_Dir, '/train/');
  train_save_dir = strcat(Spec_Save_Path, '/train/');
  if ~exist(train_save_dir)
    mkdir(train_save_dir);
  end
  train_wav_list = dir(strcat(train_data_dir,'*.wav'));
  train_len = length(train_wav_list);
  for cnt = 1:train_len
    file_name = strcat(train_data_dir, train_wav_list(cnt).name);
    [speech, fs] = audioread(file_name);
    % [s,f,t] = spectrogram(x,window,noverlap,f,fs) returns the spectrogram at the cyclical frequencies specified in f.
    [s, f_out, t] = spectrogram(speech, Spec_Window, Spec_Overlap, f, fs);
    s = abs(s);
    save_name = regexp(train_wav_list(cnt).name, '\.', 'split');
    save_name = save_name(1);
    save_name = save_name{:};
    segs_name = strcat(Segs_Save_Path, save_name);
    save_name = strcat(train_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
    % segmentation
    len = length(s(1,:));
    Segs = [];
    cnt_tmp = 0;
    for tmp = 1:(Segs_Num-Segs_Overlap):len-Segs_Num+1
      cnt_tmp = cnt_tmp + 1;
      Segs(:,cnt_tmp) = reshape(s(:,tmp:tmp+Segs_Num-1),[Segs_Num*Num_Freq, 1]);
    end
    if mod(cnt, 10) == 0
      M = [M, Segs];
    end
    save(segs_name, 'Segs');
  end

  % dev data
  dev_data_dir = strcat(Data_Dir, '/dev/');
  dev_save_dir = strcat(Spec_Save_Path, '/dev/');
  if ~exist(dev_save_dir)
    mkdir(dev_save_dir);
  end
  dev_wav_list = dir(strcat(dev_data_dir,'*.wav'));
  dev_len = length(dev_wav_list);
  for cnt = 1:dev_len
    file_name = strcat(dev_data_dir, dev_wav_list(cnt).name);
    [speech, fs] = audioread(file_name);
    % [s,f,t] = spectrogram(x,window,noverlap,f,fs) returns the spectrogram at the cyclical frequencies specified in f.
    [s, f_out, t] = spectrogram(speech, Spec_Window, Spec_Overlap, f, fs);
    s = abs(s);
    save_name = regexp(dev_wav_list(cnt).name, '\.', 'split');
    save_name = save_name(1);
    save_name = save_name{:};
    segs_name = strcat(Segs_Save_Path, save_name);
    save_name = strcat(dev_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
    % segmentation
    len = length(s(1,:));
    Segs = [];
    cnt_tmp = 0;
    for tmp = 1:(Segs_Num-Segs_Overlap):len-Segs_Num+1
      cnt_tmp = cnt_tmp + 1;
      Segs(:,cnt_tmp) = reshape(s(:,tmp:tmp+Segs_Num-1),[Segs_Num*Num_Freq, 1]);
    end
    % save a matrix to do PCA
    M = [M, Segs];
    save(segs_name, 'Segs');
  end

  % test data
  test_data_dir = strcat(Data_Dir, '/test/');
  test_save_dir = strcat(Spec_Save_Path, '/test/');
  if ~exist(test_save_dir)
    mkdir(test_save_dir);
  end
  test_wav_list = dir(strcat(test_data_dir,'*.wav'));
  test_len = length(test_wav_list);
  for cnt = 1:test_len
    file_name = strcat(test_data_dir, test_wav_list(cnt).name);
    [speech, fs] = audioread(file_name);
    % [s,f,t] = spectrogram(x,window,noverlap,f,fs) returns the spectrogram at the cyclical frequencies specified in f.
    [s, f_out, t] = spectrogram(speech, Spec_Window, Spec_Overlap, f, fs);
    s = abs(s);
    save_name = regexp(test_wav_list(cnt).name, '\.', 'split');
    save_name = save_name(1);
    save_name = save_name{:};
    segs_name = strcat(Segs_Save_Path, save_name);
    save_name = strcat(test_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
    % segmentation
    len = length(s(1,:));
    Segs = [];
    cnt_tmp = 0;
    for tmp = 1:(Segs_Num-Segs_Overlap):len-Segs_Num+1
      cnt_tmp = cnt_tmp + 1;
      Segs(:,cnt_tmp) = reshape(s(:,tmp:tmp+Segs_Num-1),[Segs_Num*Num_Freq, 1]);
    end
    % save a matrix to do PCA
    M = [M, Segs];
    save(segs_name, 'Segs');
  end
end

%% stage 2
% get and save PCA transform matrix
PCA_Abs_Max = 0;
if stage <= 2
  PCA_Save_Dir = 'pca/';
	if ~exist(PCA_Save_Dir)
	  mkdir(PCA_Save_Dir);
	end
	PCA_Num = 200;			% number of PCA
	U = pca(M, PCA_Num);
	save('PCA.mat', 'U');
	% do PCA transform for every segmentations
	segs_list = dir('segs/*.mat');
	for cnt = 1:length(segs_list)
	  file_name = strcat(segs_list(cnt).folder, '/', segs_list(cnt).name);
	  save_name = strcat(PCA_Save_Dir, segs_list(cnt).name);
	  load(file_name);
	  PCA_Segs = U' * Segs;
    tmp_max = max(max(abs(PCA_Segs)));
    if tmp_max > PCA_Abs_Max
      PCA_Abs_Max = tmp_max;
    end
    save(save_name, 'PCA_Segs');
	end
end


%% stage 3
% LCA learning
if stage <= 3
  PCA_Num = 200;
  % some parameters for LCA learning
  lca_iters = 15;
  tau_rate = 0.01;        % time-scale of dynamics
  learning_rate = 0.005;  % learning rate
  L_norm = 'L0';
  lamda = 0.1;            % relative weighting in energy function
  theta = 0.0005;
  % init the dict A
  dict_size = 200;
  A = randn(PCA_Num, dict_size);
  A = A * diag(1./sqrt(sum(A.^2)));   % norm
  pca_list = dir('pca/*_*.mat');
  for epoch = 1:50
    for cnt = 1:12:length(pca_list)-12
      tmp = [];
      for i = 0:1:11
        file_name = strcat(pca_list(cnt+i).folder, '/', pca_list(cnt+i).name);
        load(file_name);
        tmp = [tmp, PCA_Segs];
      end
      A_old = A;
      % A = lca(A_old, tmp/5, lca_iters, tau_rate, learning_rate, L_norm, lamda);
      A = lca2(A_old, tmp/5, lca_iters, tau_rate, learning_rate, L_norm, lamda, theta);
    end
    display(strcat('Epoch: ', num2str(epoch)));
	end
	save('dict.mat', 'A');
end

%% sort
[A_sort, us_sort] = show_usage(A, lca_iters, tau_rate, L_norm, lamda);

%% show the dict
plot_dict(A_sort, Num_Freq, Segs_Num, 10, 20, U);
plot_dict2(A_sort, Num_Freq, Segs_Num, 10, 20, U);
