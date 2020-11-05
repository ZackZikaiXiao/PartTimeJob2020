import cv2
import numpy as np

#   图像旋转
def rotate_bound(image, angle):
    # 获取图像的尺寸
    # 旋转中心
    (h, w) = image.shape[:2]
    (cx, cy) = (w / 2, h / 2)

    # 设置旋转矩阵
    M = cv2.getRotationMatrix2D((cx, cy), -angle, 1.0)
    cos = np.abs(M[0, 0])
    sin = np.abs(M[0, 1])

    # 计算图像旋转后的新边界
    nW = int((h * sin) + (w * cos))
    nH = int((h * cos) + (w * sin))

    # 调整旋转矩阵的移动距离（t_{x}, t_{y}）
    M[0, 2] += (nW / 2) - cx
    M[1, 2] += (nH / 2) - cy

    return cv2.warpAffine(image, M, (nW, nH))

#   二值化
def threshold_demo(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # (b, g, r) =cv2.split(image)
    # gray = b
    ret, binary = cv2.threshold(gray, 130, 255, cv2.THRESH_BINARY)
    return binary


#   泛洪填充
def fill_color_demo(image):
    copy_image = image.copy()
    h, w = image.shape[:2]
    mask = np.zeros([h+2, w+2], np.uint8)
    operater_down = (25, 25, 25)
    operater_up = (25, 25, 25)
    cv2.floodFill(copy_image, mask, (0, h-1), (120, 160, 180),
                  operater_down, operater_up, cv2.FLOODFILL_FIXED_RANGE)
    cv2.floodFill(copy_image, mask, (w-1, 0), (120, 160, 180),
                  operater_down, operater_up, cv2.FLOODFILL_FIXED_RANGE)
    cv2.floodFill(copy_image, mask, (0, 0), (120, 160, 180),
                  operater_down, operater_up, cv2.FLOODFILL_FIXED_RANGE)
    cv2.floodFill(copy_image, mask, (w-1, h-1), (120, 160, 180),
                  operater_down, operater_up, cv2.FLOODFILL_FIXED_RANGE)
    return copy_image


if __name__ == '__main__':
############################预处理#############################
    # 读取图片
    img = cv2.imread("./pic2.jpg")

    # 旋转图片
    img_rotate = rotate_bound(img, 0.8)
    # cv2.imshow('image', img_rotate)

    # 裁剪图片，先手动裁剪
    img_cropped = img_rotate[180:1250, 90:850]  # 裁剪坐标为[y0:y1, x0:x1]
    cv2.imwrite('./img_croped2.jpg', img_cropped)
    cv2.namedWindow('cropped', cv2.WINDOW_NORMAL)
    cv2.imshow('cropped', img_cropped)
    cv2.waitKey(0)
    print(img_cropped.shape)

    # 填充处理
    img_fill = fill_color_demo(img_cropped)

    #中值滤波
    img_blur = cv2.medianBlur(img_fill, 1)


    # 二值化
    img_thres = threshold_demo(img_blur)

    cv2.imshow('thres', img_thres)
    cv2.waitKey(0)
############################投影#############################
    cv2.imwrite('./preimg.jpg', img_thres)
#
#