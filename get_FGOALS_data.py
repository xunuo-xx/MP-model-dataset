import requests 
import datetime 
from bs4 import BeautifulSoup  
import sys
import os
# write by chenkangjun ckj@lasg.iap.ac.cn 20240109
url = "http://data.lasg.ac.cn/FGOALS-f3-L/" 

def getMonth_1(start,end):
    startDate = datetime.datetime.strptime(start, '%Y-%m-%d')
    endDate = datetime.datetime.strptime(end, '%Y-%m-%d')
    months = (endDate.year - startDate.year) * 12 + endDate.month - startDate.month
    # print(months)
    month_range=[]
    for x in range(0,months+1):
        nowMonth=(startDate.month-1+x)
        date='%s%s'%(startDate.year+nowMonth//12,f'{(nowMonth%12+1):02d}')
        month_range.append(date)
    return month_range

if len( sys.argv[1:]) != 4:
    print("Pls input argvs! example ###python get_FGOALS_data.py ExperimentName TableID Start_Time End_Time###")
    print("ExperimentName is amip,amip-NMO ,amip-NS-MO")
    print("TableID is 1hr,6hr,Amon,day,fx")
    print("Start_Time and End_Time see URL http://data.lasg.ac.cn/FGOALS-f3-L/")
    print("Sample Command Format:python get_FGOALS_data.py amip 1hr 2021-01-02 2021-02-02")
else:
    exp_name=sys.argv[1] 
    table_ID=sys.argv[2] 
    Start_Time=sys.argv[3]
    End_Time=sys.argv[4]

    response = requests.get(url)  
    soup = BeautifulSoup(response.text, "html.parser")  
  
# 提取所有的href标签的值  
    href_values = [a["href"] for a in soup.find_all("a")]  
    print(len(href_values))
  
# 输出href的值 
    listA=[]
    for href in href_values:  
    #     print(href)
    # wenzi="/FGOALS-f3-L/amip/r1i1p1f1/1hr/pr/gr/v20231216/pr_1hr_FGOALS-f3-L_amip_r1i1p1f1_gr_202101010030-202112161030.nc"
        str2=['/'+exp_name+'/','/'+table_ID+'/']
        str3=getMonth_1(Start_Time,End_Time)
        
        if all(string in href for string in str2) and any(x in href for x in str3): 
            listA.append(href[1:])
        
    # print(exp_name,table_ID,Start_Time,End_Time)
# print(listA)
    for i in listA:
        os.system('wget -N ' +url+i)