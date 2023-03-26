import os
from pync import Notifier

def notify():

	link = "http://127.0.0.1:8080/"
	Notifier.notify('Reminder to Blink!', title="STRAIN ALERT", open=link, sound= "default")

	Notifier.remove(os.getpid())
