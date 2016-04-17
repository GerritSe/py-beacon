from proximity import *
import sys
import signal
import json

if len(sys.argv) != 3:
  sys.exit(-1)

# bluetooth device to monitor
DEVICE = int(sys.argv[1])
# amount of measurements
ROUNDS = int(sys.argv[2])

round_counter = 0
scan_results = {}
scanner = Scanner(DEVICE, 2)

# define an iterrupt handler (e.g. when ctrl + c is pressed) to exit quietly
def interrupt_handler(signal, frame):
  sys.exit(0)

signal.signal(signal.SIGINT, interrupt_handler)

while round_counter < ROUNDS:
  scan = scanner.scan()
  for mac in scan:
    if mac in scan_results:
      scan_results[mac].append(scan[mac])
    else:
      scan_results[mac] = []

  round_counter += 1

print json.dumps(scan_results)
