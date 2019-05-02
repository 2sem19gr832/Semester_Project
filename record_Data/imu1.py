#import serial
import imu
import time

#port = serial.Serial("COM4", baudrate=115200, timeout=3.0)

with  open('filenames.txt') as file:
    name = file.readline()

with open(name + "_IMU1.txt", 'w') as file:
    while True:
        line1, line2, line3 = imu.serial_reader2()#port.readline()
        file.write(str(line1) + ' ' + str(line2) + ' ' + str(line3) + ' ' + str(time.time()) + '\n')
