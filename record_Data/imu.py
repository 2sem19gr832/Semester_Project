#!/usr/bin/env python
import time
import numpy as np
import serial
#import rospy
#from boat.msg import imudata
#import crcmod


def serial_reader():
    data = None
    raw = port.readline()
    # print(len(raw))
    if len(raw) != 0:
        data = ":".join("{:02x}".format(ord(c)) for c in raw)
    return data


def format(data1, data2, data3):
    msg = imudata()

    string = str(data1)
    length = len(string)
    string = string[1:length - 1]
    # print("######")
    # print(string)

    index1 = int(string.find(" ", 6))
    index2 = int(string.rfind(" ", index1 + 1, length - 10))
    # print("1: "+str(index1))
    # print("2: "+str(index2))

    # print(string[0:index1])
    # print(string[index1+1:index2])
    # print(string[index2:length])

    msg.time = int(round(time.time() * 1000))
    msg.gyrox = float(string[0:index1])
    msg.gyroy = float(string[index1 + 1:index2])
    msg.gyroz = float(string[index2:length])

    string = str(data2)
    length = len(string)
    string = string[1:length - 1]
    index1 = int(string.find(" ", 6))
    index2 = int(string.rfind(" ", index1 + 1, length - 10))

    msg.accx = float(string[0:index1])
    msg.accy = float(string[index1 + 1:index2])
    msg.accz = float(string[index2:length])

    string = str(data3)
    length = len(string)
    string = string[1:length - 1]
    index1 = int(string.find(" ", 6))
    index2 = int(string.rfind(" ", index1 + 1, length - 10))

    msg.incx = float(string[0:index1])
    msg.incy = float(string[index1 + 1:index2])
    msg.incz = float(string[index2:length])
    return msg


def serial_reader2():
    raw1 = None
    raw2 = None
    raw3 = None
    while raw3 != b'\x0d' or raw2 != b'\x0a' or raw1 != b'\x93':  # 0d and 0a is end of a line and 90 is msg id
        raw3 = raw2
        raw2 = raw1
        raw1 = port.read(1)

    raw = port.read(37)
    #crcval = crc32_func(
    # data=":".join("{:02x}".format(ord(c)) for c in raw)
    # data=(np.fromstring(raw[0:3] + b'\x00' + raw[3:6] + b'\x00' + raw[6:9] + b'\x00',
    data1 = (np.fromstring(raw[0:3] + b'\x00' + raw[3:6] + b'\x00' + raw[6:9] + b'\x00', dtype='>i')
             .astype(np.float32) / (2 ** (21 + 8)))

    data2 = (np.fromstring(raw[10:13] + b'\x00' + raw[13:16] + b'\x00' + raw[16:19] + b'\x00', dtype='>i')
             .astype(np.float32) / (2 ** (19 + 8)))

    data3 = (np.fromstring(raw[20:23] + b'\x00' + raw[23:26] + b'\x00' + raw[26:29] + b'\x00', dtype='>i')
             .astype(np.float32) / (2 ** (22 + 8)))

    #print("\n#####################\n")
    #print(data1)
    #print(data2)
    #print(data3)
    return data1, data2, data3


def talker():
    #pub = rospy.Publisher('imu_data', imudata, queue_size=1)
    #rospy.init_node('imu_driver', anonymous=True)
    #rate = rospy.Rate(125)  # 125
    msgnew = imudata()
    msgold = imudata()
    while True:#not rospy.is_shutdown():
        #serial_data=serial_reader()
        #print(serial_data)
        serial_data1, serial_data2, serial_data3 = serial_reader2()
        msgold = msgnew;
        msgnew = format(serial_data1, serial_data2, serial_data3)
        #rospy.loginfo(msg)
        if msgnew.accx-msgold.accx < 0.5 and msgnew.accy-msgold.accy < 0.5 and msgnew.accz-msgold.accz < 0.5 and msgnew.incx-msgold.incx < 0.5 and msgnew.incy-msgold.incy < 0.5 and msgnew.incz-msgold.incz < 0.5:
            if msgnew.accx-msgold.accx > -0.5 and msgnew.accy-msgold.accy  > -0.5 and msgnew.accz-msgold.accz  > -0.5 and msgnew.incx-msgold.incx  > -0.5 and msgnew.incy-msgold.incy  > -0.5 and msgnew.incz-msgold.incz  > -0.5:
                #pub.publish(msgnew)
                print(msgnew)
        #rate.sleep()
        
def printstuff():
    serial_data1, serial_data2, serial_data3 = serial_reader2()
    print (serial_data1)


port = serial.Serial("COM5", baudrate=921600, timeout=3.0)
#crc32_func = crcmod.mkCrcFun(0x104c11db7, initCrc=0x00000000, rev = False, xorOut=0xFFFFFFFF)
        
if __name__ == '__main__':
    port = serial.Serial("/dev/imu", baudrate=921600, timeout=3.0)
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
