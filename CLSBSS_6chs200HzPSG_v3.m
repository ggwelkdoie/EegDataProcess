clear;clc   
%% 用于将CLSBSS+BP系统采集的数据 转换为标准PSG 全导联和6导联信号 (代码修改版本 2023.3.16)
%% ========================= 单个ID号的被试数据 =================================================
eeglab;
localfile = 'D:\\matlab_tools\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc';  % 电极文件

fpath =   sprintf('D:/sleep data/Graduation_data/_BPOriginData');
fname =   sprintf('CLA011_2023_03_11_.vhdr');
subID_name ='CLA011';
RecordStartTime = [2023, 3, 11,    00, 01, 12];   % 年 月 日    时 分 秒

datasavepath ='D:/sleep data/Graduation_data/DataOut';
savenameh5 = [datasavepath, '/',subID_name,'.h5' ];
pyfilename =  'D:/MyWork/workspace/matlab/convert_HDF5_edf_func.py';

%% ---------------------------------------------------------------------------------------------------------------------------------
EEG = pop_loadbv(fpath, fname, [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35]);
EEG = eeg_checkset( EEG );

EEG = eeg_checkset( EEG );
EEG.data(33:35,:) = EEG.data(33:35,:)/100;   % AUX1 AUX2 AUX3 缩小100倍

EEG = pop_resample( EEG, 200);
EEG = eeg_checkset( EEG );

EEG = pop_rmbase( EEG, [],[]);  % 减去每通道的平均值
EEG = eeg_checkset( EEG );

% 滤波  将来注意这里滤波系数可能造成数据不稳定
tff = sleep200Hz_filtfilt_new02(double(EEG.data)');  % 肌电单独滤波
EEG.data = tff';
EEG = eeg_checkset( EEG );

% EEG=pop_chanedit(EEG, 'lookup','D:\\matlab libs\\eeglab2022.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc', ...
%     'changefield',{1,'type',''}, ...
%     'settype',{'1:32','EEG'},'settype',{'33 34','EOG'},'settype',{'35','EMG'});
% EEG = eeg_checkset( EEG );

EEG = pop_reref( EEG, [10 21] ,'exclude', [33:35] );  %重参考
EEG = eeg_checkset( EEG );

EEG = pop_saveset( EEG, 'filename', [subID_name,'.set'],'filepath',datasavepath);
EEG = eeg_checkset( EEG );
disp('---BP 全导联信号PSG 200Hz set文件结束保存 ！---')

% renew channels name
EEG=pop_chanedit(EEG, 'lookup',localfile, ...
    'changefield',{28,'labels','F4-A1'}, ...
    'changefield',{23,'labels','C4-A1'}, ...
    'changefield',{17,'labels','O2-A1'}, ...
    'changefield',{31,'labels','EOG-L'}, ...
    'changefield',{32,'labels','EOG-R'}, ...
    'changefield',{33,'labels','EMG'});

st =EEG.data([28 23 17 31 32 33],:);  %重参考后 一般选择 F4、C4、O2、AUX1 AUX2 AUX3
h5create(savenameh5, '/night', size(st));
h5write(savenameh5, '/night', st);
disp( savenameh5)
disp('---BP 6导联信号PSG 200Hz H5文件结束保存 ！---')

res = pyrunfile( ...
    pyfilename, ...
    "z",...
    filepath = datasavepath, ...
    subID = subID_name, ...
    LD = RecordStartTime);
disp('---BP 6导联信号PSG 200Hz edf文件结束保存 ！---')

