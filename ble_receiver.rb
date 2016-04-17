require_relative 'ble_multi_thread'
require 'json'

if ARGV.length < 2 then
  puts  "usage: ruby ble_receiver.rb <device-count> <rounds>\n\n" +
    "  device-count:  number of BLE receivers to monitor\n" +
    "  rounds:        amount of measurements per python call\n"
  exit
end

DEVICE_COUNT  = ARGV[0].to_i
ROUNDS        = ARGV[1].to_i
PYTHON_FILE   = File.expand_path('../ble_sniffer.py', __FILE__)

multi_threading = AIK::BLEMultiThread.new(DEVICE_COUNT)
multi_threading.start do |device_id|
  while true
    json = `python #{PYTHON_FILE} #{device_id} #{ROUNDS}`
    puts "Device #{device_id}: #{JSON.parse(json)}"
  end
end

trap('SIGINT') do
  puts "Interrupting...Please wait\n"
  multi_threading.stop
end

while multi_threading.running do
  sleep 1
end
