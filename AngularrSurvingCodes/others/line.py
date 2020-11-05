import cv2
import math

import cv2 as cv
import numpy as np


def line_detection(image):
    gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    edges = cv.Canny(gray, 50, 150, apertureSize=3)
    lines = cv.HoughLines(edges, 1, np.pi/180, 200)
    for line in lines:
        print(type(lines))
        rho, theta = line[0]
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a * rho
        y0 = b * rho
        x1 = int(x0+1000*(-b))
        y1 = int(y0+1000*(a))
        x2 = int(x0-1000*(-b))
        y2 = int(y0-1000*(a))
        cv.line(image, (x1, y1), (x2, y2), (0, 0, 255), 2)
    cv.imshow("image-lines", image)


def line_detect_possible_demo(image):
    gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    edges = cv.Canny(gray, 50, 150, apertureSize=3)
    cv.imshow("edge", edges)
    cv.waitKey(0)
    lines = cv.HoughLinesP(edges, 1, np.pi/1800, 100, minLineLength=50, maxLineGap=10)


    avg_sitaCAB = 0
    num = np.size(lines, 0)
    for line in lines:
        print(type(line))
        Ax, Ay, Cx, Cy = line[0]
        cv.line(image, (Ax, Ay), (Cx, Cy), (0, 0, 255), 2)
        sitaCAB = -math.atan((Cy - Ay)/(Cx-Ax))
        avg_sitaCAB = avg_sitaCAB + sitaCAB/num
    print("衔铁角度为:{}".format(avg_sitaCAB/math.pi*180))

    cv.imshow("line_detect_possible_demo", image)
    return avg_sitaCAB, [[Ax, Ay], [Cx, Cy]]


print("--------- Python OpenCV Tutorial ---------")
src = cv.imread("linetest.jpg")
cv.namedWindow("input image", cv.WINDOW_AUTOSIZE)
cv.imshow("input image", src)
avg_sitaCAB, lineAC = line_detect_possible_demo(src)
cv.waitKey(0)

cv.destroyAllWindows()
