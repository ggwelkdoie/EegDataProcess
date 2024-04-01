clear;clc   % CLSBSS软件系统保存的数据 包含 Fz，因此提取35导联 (代码修改版本 2023.2.17)
for i = 1 %不循环
   %% --------------------------------------------------------------------------------------------------
   
   fpath = sprintf('D:\\MyWork\\workspace\\matlab');
   fname = sprintf('CLA009_2023_03_10_.vhdr');
   PatientNameStr = 'wanglin';
   YYYY=2023; MM=2; DD=17; 
   HH=23; mm=18;  
   RecordStartTime = [YYYY MM DD HH mm 01.001];   
   savename = ['.\\CLA009_', PatientNameStr, '.edf'];
   
   %% --------------------------------------------------------------------------------------------------
   localfile = 'C:\\Program Files\\Polyspace\\R2021a\\toolbox\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc';   
   eeglab;
   EEG = pop_loadbv(fpath, fname, [], [1:35]);  % CLSBSS软件系统保存的数据 包含 Fz，因此提取35导联
   EEG = eeg_checkset( EEG );
   

   EEG.data(33:35,:) = EEG.data(33:35,:)/100;  % CLSBSS在线软件系统保存的BP数据（非官方Recorder软件），AUX通道 幅度除以100
   EEG = eeg_checkset( EEG );
   % resample
   EEG = pop_resample( EEG, 200);
   EEG = eeg_checkset(EEG);
   
   Lepoch = 30*200;
    epochnum = floor(EEG.pnts/Lepoch);
    for epochi = 0:(epochnum)
        if epochi == 0
            t = ...
                EEG.data([1:34],(1+epochi*Lepoch):(Lepoch+epochi*Lepoch+5)) - ...
                repmat(mean(EEG.data([1:34],(1+epochi*Lepoch):(Lepoch+epochi*Lepoch+5)),2),[1 Lepoch+5]);
            x = ...
                EEG.data([1:34],(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)) - ...
                repmat(mean(EEG.data([1:34],(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)),2),[1 Lepoch+10]);
            load('IIR-HP-EEG-Fs200-Fstop0.1-Fpass0.3-Apass0.05-Astop60.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EEG-Fs200-Fstop47-Fpass41-Apass0.05-Astop43.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data([1:34],1:Lepoch) = t(:,1:Lepoch);
        elseif epochi == (epochnum)
            t = x;
            load('IIR-HP-EEG-Fs200-Fstop0.1-Fpass0.3-Apass0.05-Astop60.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EEG-Fs200-Fstop47-Fpass41-Apass0.05-Astop43.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data([1:34],(1+epochi*Lepoch):EEG.pnts) = t(:,6:end);
        else
            t = x;
            if epochi == (epochnum-1)
                x = ...
                    EEG.data([1:34],(1+(epochi+1)*Lepoch-5):EEG.pnts) - ...
                    repmat(mean(EEG.data([1:34],(1+(epochi+1)*Lepoch-5):EEG.pnts),2),[1 (EEG.pnts-((epochi+1)*Lepoch)+5)]);
            else
                x = ...
                    EEG.data([1:34],(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)) - ...
                    repmat(mean(EEG.data([1:34],(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)),2),[1 Lepoch+10]);
            end
            load('IIR-HP-EEG-Fs200-Fstop0.1-Fpass0.3-Apass0.05-Astop60.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EEG-Fs200-Fstop47-Fpass41-Apass0.05-Astop43.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data([1:34],(1+epochi*Lepoch):(Lepoch+epochi*Lepoch)) = t(:,6:Lepoch+5);
        end
    end
    for epochi = 0:(epochnum)
        if epochi == 0
            t = ...
                EEG.data(35,(1+epochi*Lepoch):(Lepoch+epochi*Lepoch+5)) - ...
                repmat(mean(EEG.data(35,(1+epochi*Lepoch):(Lepoch+epochi*Lepoch+5)),2),[1 Lepoch+5]);
            x = ...
                EEG.data(35,(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)) - ...
                repmat(mean(EEG.data(35,(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)),2),[1 Lepoch+10]);
            load('IIR-BS-EMG-Fs200-Fpass47-Fpass53-Apass0.05-Astop23.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-HP-EMG-Fs200-Fstop6-Fpass9-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EMG-Fs200-Fstop99-Fpass92-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data(35,1:Lepoch) = t(:,1:Lepoch);
        elseif epochi == (epochnum)
            t = x;
            load('IIR-BS-EMG-Fs200-Fpass47-Fpass53-Apass0.05-Astop23.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-HP-EMG-Fs200-Fstop6-Fpass9-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EMG-Fs200-Fstop99-Fpass92-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data(35,(1+epochi*Lepoch):EEG.pnts) = t(:,6:end);
        else
            t = x;
            if epochi == (epochnum-1)
                x = ...
                    EEG.data(35,(1+(epochi+1)*Lepoch-5):EEG.pnts) - ...
                    repmat(mean(EEG.data(35,(1+(epochi+1)*Lepoch-5):EEG.pnts),2),[1 (EEG.pnts-((epochi+1)*Lepoch)+5)]);
            else
                x = ...
                    EEG.data(35,(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)) - ...
                    repmat(mean(EEG.data(35,(1+(epochi+1)*Lepoch-5):(Lepoch+(epochi+1)*Lepoch+5)),2),[1 Lepoch+10]);
            end
            load('IIR-BS-EMG-Fs200-Fpass47-Fpass53-Apass0.05-Astop23.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-HP-EMG-Fs200-Fstop6-Fpass9-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            load('IIR-LP-EMG-Fs200-Fstop99-Fpass92-Apass0.05-Astop40.mat');
            t = single(filtfilt(b, a, double(t)'))';
            EEG.data(35,(1+epochi*Lepoch):(Lepoch+epochi*Lepoch)) = t(:,6:Lepoch+5);
        end
    end
    EEG = eeg_checkset( EEG );
    
    % BP Recorder 数据 则要添加Fz 
%     EEG = pop_chanedit(EEG, 'append', 34, 'changefield', {35,'labels','Fz'},'lookup',localfile, 'setref', {'1:31 35','Fz'});
%     EEG = eeg_checkset( EEG );  
    % 排除眼电肌电
%     EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Fz'},'type',{''},'theta',{0.30571},'radius',{0.22978},'X',{58.512},'Y',{-0.3122},'Z',{66.462},'sph_theta',{-0.30571},'sph_phi',{48.6395},'sph_radius',{88.5491},'urchan',{35},'ref',{'Fz'},'datachan',{0}),'exclude',[32:34]);
%     EEG = eeg_checkset( EEG );
    EEG = pop_reref(EEG,[10 21],'exclude',[33:35]);  % 排除眼电肌电
    EEG = eeg_checkset( EEG );
    
    % renew channels name
    EEG=pop_chanedit(EEG, 'lookup',localfile, 'changefield',{17,'labels','O2-A1'},'changefield',{23,'labels','C4-A1'},'changefield',{28,'labels','F4-A1'},'changefield',{31,'labels','EOG-R'},'changefield',{32,'labels','EOG-L'},'changefield',{33,'labels','EMG'});
    EEG = eeg_checkset( EEG );    
    EEG = pop_select( EEG, 'channel',{'F4-A1', 'C4-A1', 'O2-A1', 'EOG-L', 'EOG-R', 'EMG'});
    EEG = eeg_checkset( EEG );
    
     % 修改底层writeeeg函数 absMax = 10000;
     % 去除status通道，注释掉底层writeeeg函数 190行到203行
    pop_writeeeg(EEG,savename, 'TYPE','EDF', 'Patient.Name', PatientNameStr, 'T0', RecordStartTime);  % Nan可能是因为幅值过大
    disp('--- 结束保存 ！---')
end

