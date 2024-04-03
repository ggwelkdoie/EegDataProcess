function out = sleep200Hz_filtfilt_new02(Xmatrix)
% 每一列是一导联信号 35导联
% Xmatrix = Xmatrix';
%===============================================================================================================================
EEG_HP_200Hz_b = [0.986028969792555,-4.93012099229664,9.86021812804589,-9.86021812804589,4.93012099229664,-0.986028969792555];
EEG_HP_200Hz_a = [1,-4.97184244871153,9.88777893635960,-9.83227807241017,4.88858915383008,-0.972247568958807];

EEG_LP_200Hz_b = [0.0425224080751737,0.0657859204565549,0.141110245426128,0.164540369398614,0.164540369398614,0.141110245426128,0.0657859204565549,0.0425224080751737];
EEG_LP_200Hz_a = [1,-1.98640151004731,3.47722004645338,-3.42146191891360,2.73725385684849,-1.39384783848801,0.501602779095953,-0.0864475282359609];

tmp0 = filtfilt(EEG_HP_200Hz_b, EEG_HP_200Hz_a, [Xmatrix(:, 1:33)]);  % 总共35导联信号，1:34是脑电和眼电
out1 = filtfilt(EEG_LP_200Hz_b, EEG_LP_200Hz_a, tmp0);

%===============================================================================================================================
EMG_HP_200Hz_b = [0.694927796512212,-3.44083292743820,6.84821157730918,-6.84821157730918,3.44083292743820,-0.694927796512212];
EMG_HP_200Hz_a = [1,-4.23120350223315,7.24875644319993,-6.27144809418586,2.73599170397489,-0.480544858925363];

EMG_LP_200Hz_b = [0.841275323307107,2.52120830566221,2.52120830566221,0.841275323307107];
EMG_LP_200Hz_a = [1,2.65307851570668,2.36532996114126,0.706558781090710];

EMG_BS_200Hz_b = [0.891628635083466,-8.52109758199577e-16,2.66951866059954,-1.70355928838567e-15,2.66951866059954,-8.52109758199577e-16,0.891628635083466];
EMG_BS_200Hz_a = [1,-3.92310075966856e-16,2.76563170083677,-2.91782195653621e-16,2.56233029720171,3.88920797506299e-17,0.794332593327542];

tmp1 = filtfilt(EMG_HP_200Hz_b, EMG_HP_200Hz_a, Xmatrix(:,34));
tmp2 = filtfilt(EMG_LP_200Hz_b, EMG_LP_200Hz_a, tmp1);
out2 = filtfilt(EMG_BS_200Hz_b, EMG_BS_200Hz_a, tmp2);
out = [out1, out2];
%===============================================================================================================================




end