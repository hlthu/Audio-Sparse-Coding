close all; clear all; clc;
stage = 1;

%% some configs for Spectrograms
Num_Freq = 256;                           % number of frequencies
Freq_Sample = 16000;                      % Sample rate
Spec_Window = Freq_Sample * 40 / 1000;    % length of window for Spec
Spec_Overlap = Spec_Window / 2;           % overlap of window for Spec
Spec_Low_Freq = 100;
Spec_High_Freq = 4000;
Spec_Save_Path = 'spec';

%% some configs about timit set
Data_Dir = 'data';


%% stage 1
% generate spectrograms
if stage <= 1
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
    save_name = strcat(train_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
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
    save_name = strcat(dev_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
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
    save_name = strcat(test_save_dir, save_name);
    save(save_name, 's', 'f_out', 't');
  end

end