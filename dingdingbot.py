import time, sys
from dingtalkchatbot.chatbot import DingtalkChatbot
import os, base64

webhook = os.getenv('WEBHOOK')
secret = os.getenv('SECRET')

commitID = str(sys.argv[1])
commitMessage = str(base64.b64decode(sys.argv[2]),'utf-8')
result1 = str(base64.b64decode(sys.argv[3]),'utf-8')
result2 = str(base64.b64decode(sys.argv[4]),'utf-8')
result3 = str(base64.b64decode(sys.argv[5]),'utf-8')
spend_time = str(sys.argv[6])

load5 = os.popen("cat /proc/loadavg | cut -b 6-10").read().strip()
load = str(sys.argv[7])


systembot = DingtalkChatbot(webhook, secret=secret)
t = time.localtime()
systembot.send_markdown(title='NixOS 部署情况', text='#### '+ commitMessage +'\n'
                    '- commitID: ' + commitID +'  \n'
                    '- result: ' +'  \n'
                    '> ' + result1 + ' \n'
                    '> ' + result2 + ' \n'
                    '> ' + result3 + ' \n'
                    '- time: ' + spend_time + 's, end at ' + time.strftime("%H:%M:%S %Y-%m-%d", time.localtime())  +'  \n'
                    '- load: ' + load + "; " + load5 +'(5min)  \n')
                    