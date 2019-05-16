import numpy
from PIL import Image

def voronoi(points,shape=(300,300)):
    depthmap = numpy.ones(shape,numpy.float)*1e308
    colormap = numpy.zeros(shape,numpy.int)

    def hypot(X,Y):
        return (X-x)**2 + (Y-y)**2

    for i,(x,y) in enumerate(points):
        paraboloid = numpy.fromfunction(hypot,shape)
        colormap = numpy.where(paraboloid < depthmap,i+1,colormap)
        depthmap = numpy.where(paraboloid < depthmap,paraboloid,depthmap)

    for (x,y) in points:
        colormap[x-1:x+2,y-1:y+2] = 0
    
    return colormap;

def rgb_to_hex(red, green, blue):
    return '#%02x%02x%02x' % (red, green, blue)

def draw_map(colormap,points):
    shape = colormap.shape
    #palarray = []
    #for i in range(len(points)):
    #    palarray[i] = rgb_to_hex(0+i*3,0+i*3,0+i*3)
    
    #print(palarray)
    palette = numpy.array([0x000000FF, 0x1A1A1AFF, 0x333333FF, 0x4D4D4DFF, 0x666666FF, 0x808080FF, 0x999999FF, 0xB3B3B3FF, 0xCCCCCCFF, 0xE6E6E6FF ])
    #                                      blue                  red          green
#1a=10 33=20 4D=30 66=40 80=50 99=60 B3=70 CC=80 E6=90
    colormap = numpy.transpose(colormap)
    pixels = numpy.empty(colormap.shape+(4,),numpy.int8)

    pixels[:,:,3] = palette[colormap] & 0xFF
    pixels[:,:,2] = (palette[colormap]>>8) & 0xFF
    pixels[:,:,1] = (palette[colormap]>>16) & 0xFF
    pixels[:,:,0] = (palette[colormap]>>24) & 0xFF

    i = Image.open('testimg.PNG')
    imgSize = i.size
    image = Image.frombytes("RGBA",shape,pixels)
    image.save('voronoi3.png')

if __name__ == '__main__':
    points = ([150,150],[130,130],[170,170],[170,130],[130,170],[120,120],[185,180],[180,185])
    draw_map(voronoi(points),points)
