
from pyedflib import EdfWriter, FILETYPE_EDFPLUS, EdfReader
import h5py
import datetime

def Convert_hdf5edf(filepath='D:/mainwork/MyJustTest_Workspace/SleepCLSBSS_DataOut_WP/DataOut',
                    subID='CL008_xianghaiquan_2023_02_17_',
                    LD=None):
    if LD is None:
        LD = [2023, 3, 1, 23, 59, 10]

    sttime = datetime.datetime(int(LD[0]), int(LD[1]), int(LD[2]), int(LD[3]), int(LD[4]), int(LD[5]))
    # ============================================================================
    # ============================================================================
    with h5py.File(filepath+'/'+subID+'.h5', 'r') as f:
        datasignals = f['night'][:].T
    saveedffilename = filepath+'/'+subID+'.edf'
    ch_num=6
    labelname = ('F4-A1', 'C4-A1', 'O2-A1', 'EOG-L', 'EOG-R', 'EMG')  # edf的通道顺序 严格按照此顺序
    channel_info = []
    for chi in range(0, ch_num):
        ch_dict = {'label': labelname[chi], 'dimension': 'uV',
                   'sample_rate': 200, 'physical_max': 20000, 'physical_min': -20000,
                   'digital_max': 20000, 'digital_min': -20000,  # 20mV
                   'transducer': '-',   # --- 修改 放大器设备命名
                   'prefilter': "-"}  # ---修改 滤波器信息
        channel_info.append(ch_dict)

    fedf = EdfWriter(saveedffilename, ch_num, file_type=FILETYPE_EDFPLUS)
    fedf.setSignalHeaders(channel_info)
    fedf.setStartdatetime(sttime) #  日期时间  日 月 年 时:分:秒
    fedf.writeSamples(datasignals)
    print('      \n          转 换 成 功 ！  ', saveedffilename)
    fedf.close()
    del fedf
    return 0



#===== 用于 matlab 外部调用 =================
#===== 用于 matlab 外部调用 =================

z = Convert_hdf5edf(filepath, subID, LD)

    # print('------')
    # start_id = 31  # ID号 有起点，因为涉及到不同批次的数据，所以本批次的数据序号起点要注意！！！
    # id_num = 20  # 被试个数
    # for subi in range(id_num):
    #     subIDname = 'WB%03d' % (subi+start_id)
    #     datasignals = Convert_hdf5edf(
    #         filepath='D:/mainwork/MyJustTest_Workspace/SleepCLSBSS_DataOut_WP/BP_6chs200HzPSG_v2_2022YSH20subjects',
    #         subID=subIDname)




