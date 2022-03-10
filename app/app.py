import os
import sys
import linecache
import datetime
import requests
import json
import pyttsx3

CUR_ABSPATH = os.path.abspath('.')
DEBUG = "false"
TASK_FLAG = ""

# 文字转语音
def Text2Voice():

    # 倒计时天数等
    time, count_before, count_after = get_time()

    # 从本地文本获取每日一句
    slogan_path = CUR_ABSPATH+'\\app\\slogan_a.txt'
    slogan = get_line_context(slogan_path, count_after)

    if TASK_FLAG == "en_task":
        # 从网络获取鸡汤
        jitang, translation = get_web_slogan()
        if jitang:
            slogan = jitang + translation + "接下来是英语听力："
        else:
            slogan = slogan + "接下来是英语听力："
    elif TASK_FLAG == "cn_task":
        slogan = slogan + "接下来一起背古诗文："

    count_down_text = '你已奋斗了{}天，现在距离高考还有{}天，加油！'.format(
        count_before, count_after) + '\n'
    a = '每日一句\n'
    time = '今天是' + time

    # 语音内容
    text = " 你好同学！" + time + count_down_text + a + slogan  
    # 语音合成
    engine = pyttsx3.init()  # object creation
    # 更改声音
    voices = engine.getProperty('voices')
    # for voice in voices:
    #     print("ID: %s" % voice.id)
    #     print("Name: %s" % voice.name)
    #     print("Age: %s" % voice.age)
    #     print("Gender: %s" % voice.gender)
    #     print("Languages Known: %s" % voice.languages)

    engine.setProperty('rate', 180)
    engine.setProperty('voice', voices[0].id)
    # 把语音存储到文件
    engine.save_to_file(text, CUR_ABSPATH+'/slogan.mp3')
    if DEBUG == "true":
        engine.say(text)
    engine.runAndWait()
    engine.stop()

# 获取日期和倒计时
def get_time():

    dt = datetime.datetime.now()
    # dt = datetime.datetime(2022,3,8)
    # 计算已学习的天数
    start_dt = datetime.datetime(2011, 9, 1)  # 上学时间
    count_before = (dt - start_dt).days
    # 计算倒计时天数
    success_dt = datetime.datetime(2022, 6, 7)  # 高考时间
    count_after = (success_dt - dt).days
    # 当前日期转换成字符串
    year = str(dt.year)
    month = str(dt.month)
    day = str(dt.day)
    time = year + '年' + month + '月' + day + '日' + '\n'

    return time, count_before, count_after


# 读取文件指定行内容
def get_line_context(file_path, line_number):
    return linecache.getline(file_path, line_number).strip()

# 获取每日鸡汤
def get_web_slogan():
    return None, None
    try:
        url = 'http://open.iciba.com/dsapi/'
        response = requests.get(url=url)
        json_s = json.loads(response.text)
        jitang = json_s.get("content") + '\n'
        translation = json_s.get("note") + '\n'
        return jitang, translation
    except requests.exceptions.RequestException as err:
        return None, None


if __name__ == "__main__":
    if len(sys.argv) > 1:
        TASK_FLAG = sys.argv[1]
    if len(sys.argv) > 2:
        DEBUG = sys.argv[2]

    Text2Voice()
