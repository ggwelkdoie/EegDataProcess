clear;clc   
%% 用于将Recorder+BP系统采集的数据 转换为标准PSG 全导联和6导联信号 (代码修改版本 2023.3.16)
%% ========================= 单个ID号的被试数据 =================================================
eeglab;
localfile = 'D:\softwave\matlab_tools\eeglab2022.0\plugins\dipfit\standard_BEM\elec\\standard_1005.elc';  % 电极文件

fpath =   sprintf('F:\CHANGING\Notebook computer\experiment\experiment data\ymj exp data\YSF-sleep-data\SLP001_0505\');
fname =   sprintf('SLP001.vhdr');
subID_name ='ML005-2';
RecordStartTime = [2023, 4, 7,    23, 44, 41];   % 年 月 日    时 分 秒

datasavepath ='E:\YSF';
% savenameh5 = [datasavepath, '/',subID_name,'.h5' ];
savename = [datasavepath, '/BP-', 'SLP020.edf'];
pyfilename =  'D:/MyWork/workspace/matlab/convert_HDF5_edf_func.py';

%% ---------------------------------------------------------------------------------------------------------------------------------
% EEG = pop_loadbv(fpath, fname, [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34]);
EEG = pop_loadbv('F:\CHANGING\Notebook computer\experiment\experiment data\ymj exp data\YSF-sleep-data\SLP020_0524\', 'SLP020.vhdr', [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34]);
EEG = eeg_checkset( EEG );

% EEG = eeg_checkset( EEG );
% EEG.data(33:35,:) = EEG.data(33:35,:)/100;   % AUX1 AUX2 AUX3 缩小100倍

EEG = pop_resample( EEG, 200);
EEG = eeg_checkset( EEG );

EEG = pop_rmbase( EEG, [],[]);  % 减去每通道的平均值
EEG = eeg_checkset( EEG );

% 滤波  将来注意这里滤波系数可能造成数据不稳定
tff = sleep200Hz_filtfilt_new03(double(EEG.data)');  % 第34导联：肌电单独滤波
EEG.data = tff';
EEG = eeg_checkset( EEG );

% EEG=pop_chanedit(EEG, 'lookup','D:\\matlab libs\\eeglab2022.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc', ...
%     'changefield',{1,'type',''}, ...
%     'settype',{'1:32','EEG'},'settype',{'33 34','EOG'},'settype',{'35','EMG'});
% EEG = eeg_checkset( EEG );

EEG = pop_chanedit(EEG, 'append', 34, 'changefield', {35,'labels','Fz'},'lookup',localfile, 'setref', {'1:31 35','Fz'});
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, ...
    'lookup',localfile, ...
    'changefield',{32,'labels','EOG-L'}, ...
    'changefield',{33,'labels','EOG-R'}, ...
    'changefield',{34,'labels','EMG'});
EEG = eeg_checkset( EEG );


EEG = pop_reref( EEG, [9 20] , ...
    'refloc',struct('labels',{'Fz'},'type',{''},'theta',{0.30571},'radius',{0.22978},'X',{58.512},'Y',{-0.3122},'Z',{66.462},'sph_theta',{-0.30571},'sph_phi',{48.6395},'sph_radius',{88.5491}, ...
    'urchan',{35},'ref',{'Fz'},'datachan',{0}),'exclude',[32:34] );
EEG = eeg_checkset( EEG );

EEG.data = [EEG.data(1,:); EEG.data(33,:); EEG.data(2:32,:)];
EEG.chanlocs = [EEG.chanlocs(1), EEG.chanlocs(33), EEG.chanlocs(2:32)];
for i =1:33
    EEG.chanlocs(i).urchan = i;
end
EEG = eeg_checkset( EEG );

% EEG = pop_saveset( EEG, 'filename', [subID_name,'_all.set'],'filepath',datasavepath);
% EEG = eeg_checkset( EEG );
% disp('---BP 全导联信号PSG 200Hz set文件结束保存 ！---')

% pop_writeeeg(EEG, [datasavepath,'/',subID_name, '_all.edf'], 'TYPE','EDF');
pop_writeeeg(EEG, savename, 'TYPE','EDF');
disp('---BP 全导联信号PSG 200Hz edf文件结束保存 ！---')

% st =EEG.data([28,23,17,31,32,33], :);  
% h5create(savenameh5, '/night', size(st));
% h5write(savenameh5, '/night', st);
% disp( savenameh5)
% disp('---BP 6导联信号PSG 200Hz H5文件结束保存 ！---')
% 
% res = pyrunfile( ...
%     pyfilename, ...
%     "z",...
%     filepath = datasavepath, ...
%     subID = subID_name, ...
%     LD = RecordStartTime);
% disp('---BP 6导联信号PSG 200Hz edf文件结束保存 ！---')


