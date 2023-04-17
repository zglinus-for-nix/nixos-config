import time, sys
from dingtalkchatbot.chatbot import DingtalkChatbot
import os

webhook = os.getenv('WEBHOOK')
secret = os.getenv('SECRET')

commitID = str(sys.argv[1])
commitMessage = str(sys.argv[2])
result = str(sys.argv[3])

load5 = os.popen("cat /proc/loadavg | cut -b 6-10").read().strip()

systembot = DingtalkChatbot(webhook, secret=secret)
t = time.localtime()
systembot.send_markdown(title='NixOS 部署情况', text='#### '+ commitMessage +'\n'
                    '- commitID: ' + commitID +'  \n'
                    '- result: ' + result +'  \n'
                    '- time: ' + time.asctime( time.localtime(time.time()) ) +'  \n'
                    '- load5: ' + load5 +'  \n')
                    