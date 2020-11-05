import cv2 as cv
import numpy as np


def template_demo():
    # img = cv.imread('raw.jpg')
    img = cv.imread('./photo/03465278.bmp')
    template = cv.imread("../stickright.jpg")


    # methods = [cv.TM_SQDIFF_NORMED, cv.TM_CCORR_NORMED, cv.TM_CCOEFF_NORMED]
    h, w = template.shape[:2]

    # 相关系数匹配方法：cv2.TM_CCOEFF
    res = cv.matchTemplate(img, template, cv.TM_CCOEFF)
    min_val, max_val, min_loc, max_loc = cv.minMaxLoc(res)

    left_top = max_loc  # 左上角
    right_bottom = (left_top[0] + w, left_top[1] + h)  # 右下角
    cv.rectangle(img, left_top, right_bottom, 255, 2)  # 画出矩形位置
    cv.imshow("show",img)
    cv.waitKey(0)


print("--------- Python OpenCV Tutorial ---------")
src = cv.imread('./raw.jpg')
cv.namedWindow("input image", cv.WINDOW_AUTOSIZE)
cv.imshow("input image", src)
template_demo()
cv.waitKey(0)

cv.destroyAllWindows()



# src = cv.imread('./raw.jpg')
# src = cv.split(src)[0]
# src = src[500:560, 650:750]
# print(src.shape)
# cv.imshow("input image", src)
# cv.imwrite("./stickright.jpg",src)
# cv.waitKey(0)