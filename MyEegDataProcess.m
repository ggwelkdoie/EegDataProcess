clear; clc;
eeglab;
localfile = 'C:\\Program Files\\MATLAB\\R2022b\\toolbox\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc';
mainFolderPath = 'E:\\WLwork\\data\\JR';
folders = dir(mainFolderPath);
for i = 1:length(folders)
    if folders(i).isdir && ~startsWith(folders(i).name, '.')
        subFolderPath = fullfile(mainFolderPath, folders(i).name);
        files = dir(fullfile(subFolderPath, '*.vhdr'));
        if ~isempty(files)
            filePath = fullfile(subFolderPath, files(1).name);
            fprintf('找到文件：%s\n', filePath);
            savefile = sprintf('E:\\WL work\\data\\EEG_6\\subject%02d_6.edf', i+18);

            EEG = pop_loadbv(subFolderPath, files(1).name, [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34]);
            EEG = eeg_checkset( EEG );

            EEG.data(32:34,:) = EEG.data(32:34,:)/100;   % AUX1 AUX2 AUX3 缩小100倍
            EEG = eeg_checkset( EEG );

            EEG = pop_resample( EEG, 200);
            EEG = eeg_checkset( EEG );

            EEG = pop_rmbase( EEG, [],[]);  % 减去每通道的平均值
            EEG = eeg_checkset( EEG );

            tff = sleep200Hz_filtfilt_new02(double(EEG.data)');  % 肌电单独滤波
            EEG.data = tff';
            EEG = eeg_checkset( EEG );

            EEG = pop_chanedit(EEG, 'append', 34, 'changefield', {35,'labels','Fz'},'lookup',localfile, 'setref', {'1:31 35','Fz'});
            EEG = eeg_checkset( EEG );
            EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Fz'},'type',{''},'theta',{0.30571},'radius',{0.22978},'X',{58.512},'Y',{-0.3122},'Z',{66.462},'sph_theta',{-0.30571},'sph_phi',{48.6395},'sph_radius',{88.5491},'urchan',{35},'ref',{'Fz'},'datachan',{0}),'exclude',[32:34]);
            EEG = eeg_checkset( EEG );

            EEG = pop_reref( EEG, [10 21] ,'exclude', [32:34] );  %重参考
            EEG = eeg_checkset( EEG );

            EEG=pop_chanedit(EEG, ...
                'lookup',localfile, ...
                'changefield',{30,'labels','EOG-L'}, ...
                'changefield',{31,'labels','EOG-R'}, ...
                'changefield',{32,'labels','EMG'});
            EEG = eeg_checkset( EEG );

%             pop_writeeeg(EEG, savefile, 'TYPE','EDF');
%             disp('---BP 全导联信号PSG 200Hz edf文件结束保存 ！---')
            res = pyrunfile( ...
                pyfilename, ...
                "z",...
                filepath = datasavepath, ...
                subID = subID_name, ...
                LD = RecordStartTime);
            disp('---BP 6导联信号PSG 200Hz edf文件结束保存 ！---')
        else
            fprintf("在文件夹 %s 中未找到.vhdr文件.\n", subFolderPath);
        end
    end
end