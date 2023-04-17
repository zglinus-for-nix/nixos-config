import time, sys
from dingtalkchatbot.chatbot import DingtalkChatbot
import os, base64

webhook = os.getenv('WEBHOOK')
secret = os.getenv('SECRET')

commitID = str(sys.argv[1])
commitMessage = str(base64.b64decode(sys.argv[2]),'utf-8')
result = str(base64.b64decode(sys.argv[3]),'utf-8')

load5 = os.popen("cat /proc/loadavg | cut -b 6-10").read().strip()

systembot = DingtalkChatbot(webhook, secret=secret)
t = time.localtime()
systembot.send_markdown(title='NixOS 部署情况', text='#### '+ commitMessage +'\n'
                    '- commitID: ' + commitID +'  \n'
                    '- result: ' + result +'  \n'
                    '- time: ' + time.asctime( time.localtime(time.time()) ) +'  \n'
                    '- load5: ' + load5 +'  \n')
                    