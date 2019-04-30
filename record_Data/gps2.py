import serial
import time

port = serial.Serial("COM4", baudrate=115200, timeout=3.0)

with  open('filenames.txt') as file:
    name = file.readline()

with open(name + "_GPS2.txt", 'w') as file:
    for i in range (10000):
        line = port.readline()
        file.write(line.decode('ascii') + ' ' + str(time.time()))