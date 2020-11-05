# tkinter,即Python Imaging Library，是Python的图像处理标准库
from tkinter import filedialog
import tkinter as tk
# Python Imaging Library已经是Python平台的图像处理标准库
import PIL.Image
import PIL.ImageTk
# cv2, 即opencv, 开源图像处理包，含有图像Tools中的预处理函数和霍夫直线检测函数
import cv2
# numpy, python的科学计算包
import numpy as np
# math, 计算角度时会用到三角函数
import math
import copy

# 图像处理工具包类
class Tools:
    #   二值化
    def threshold_demo(self, image):
        # 大津阈值设定过高,导致右侧干扰严重,手动阈值在100左右较好
        # gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        ret, binary = cv2.threshold(image, 100, 255, cv2.THRESH_BINARY)
        return binary

    # 腐蚀
    def dilate_demo(self, image, degree):
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, degree)
        dst = cv2.erode(image, kernel)
        return dst

    # 膨胀
    def erode_demo(self, image, degree):
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, degree)
        dst = cv2.dilate(image, kernel)
        return dst

    # 图像分割图像预处理
    def segmengt_preprocessing(self, img_pre):
        img_pre = self.threshold_demo(img_pre)    # 二值化
        img_pre = cv2.medianBlur(img_pre, 5)  # 中值滤波
        img_pre = self.erode_demo(img_pre, (15, 15))        # 腐蚀
        # img_pre = self.dilate_demo(img_pre, (2, 2))       # 膨胀
        # cv2.imshow("2.pre", img_pre)

        return img_pre


    # 计算左衔铁的位置
    def template_left(self, img):
        # 载入模板匹配的模板，故这张图必须与主文件放置在同一文件夹内
        template = cv2.imread("./stickleft.jpg")
        # imgtemp = copy.deepcopy(img)
        # methods = [cv.TM_SQDIFF_NORMED, cv.TM_CCORR_NORMED, cv.TM_CCOEFF_NORMED]
        h, w = template.shape[:2]

        # 相关系数匹配方法：cv2.TM_CCOEFF
        # 也可根据效果更换为其他匹配方法，可查询"opencv模板匹配方法"
        res = cv2.matchTemplate(img, template, cv2.TM_CCOEFF)
        # 获取匹配信息，其中max_loc为匹配结果左上角坐标
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

        left_top = max_loc  # 左上角
        # 根据模板的长宽得到最终匹配结果的左上,右下坐标(即检测到的左衔铁的范围)
        right_bottom = (int(left_top[0] + 0.8*w), int(left_top[1] + 0.9*h))  # 右下角
        left_top = (int(left_top[0] + 0.1*w), int(left_top[1] + 0.2*h))
        # cv2.rectangle(img, left_top, right_bottom, 255, 2)  # 画出矩形位置
        # cv2.namedWindow("show", cv2.WINDOW_NORMAL)
        # cv2.imshow("show", img)
        # cv2.imshow('./linetest.jpg', imgtemp[left_top[1]:right_bottom[1], left_top[0]:right_bottom[0]])
        # cv2.waitKey(0)
        return [left_top, right_bottom]


    # 原理与template_left函数相同，检测右衔铁位置。计算right_bottom和left_top时有所不同。
    def template_right(self, img):
        template = cv2.imread("./stickright.jpg")
        h, w = template.shape[:2]
        # 相关系数匹配方法：cv2.TM_CCOEFF
        res = cv2.matchTemplate(img, template, cv2.TM_CCOEFF)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

        left_top = max_loc  # 左上角
        right_bottom = (int(left_top[0] + 2.2*w), int(left_top[1] + 3*h))  # 右下角
        left_top = (int(left_top[0]+0.5*w), int(left_top[1]+0.5*h))
        # cv2.rectangle(img, left_top, right_bottom, 255, 2)  # 画出矩形位置
        # cv2.imshow("show", img)
        # cv2.waitKey(0)
        return [left_top, right_bottom]


# 针对衔铁检测的类，继承Tools类，可直接使用Tools中的图像处理函数
class AngularCalc(Tools):

    def __init__(self, src):
        self.src = src
        self.img_draw = copy.deepcopy(self.src)
    
    
    #检测左侧衔铁角度
    def line_detect_Left(self, leftArea):
        # image为裁剪后的左衔铁图像
        image = self.src[leftArea[0][1]:leftArea[1][1], leftArea[0][0]:leftArea[1][0]]
        # 中值滤波
        image = cv2.medianBlur(image, 3)  
        # 彩色变为灰色
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        # 提取Canny边缘，以直线检测
        edges = cv2.Canny(gray, 50, 150, apertureSize=3)
        # cv2.imshow("left_edge", edges)
        # cv2.waitKey(0)
        # 直线检测，self.left_lines数组中有每一个检测到的线段的首尾两点坐标
        # 最小检测角度为1°，分辨率Pi/1800，最小可识别线段长度为80像素，若检测到的同方向线段间距小于10，则识别成一条线段
        self.left_lines = cv2.HoughLinesP(edges, 1, np.pi / 1800, 100, minLineLength=80, maxLineGap=10)
        # 设衔铁轴心为点B，左侧端点为点A，右侧端点为点C
        # self.avg_sitaCAB是角CAB夹角(角度制)，self.avg_sitaCB_Infinity是角CBA补角，self.avg_sitaCB_Infinity减去self.avg_sitaCAB等于角ACB(衔铁夹角)。可画图验证。
        self.avg_sitaCAB = 0
        # num为检测到的线段数量
        num = np.size(self.left_lines, 0)
        for line in self.left_lines:
        # A,C点的x,y轴坐标
            Ax, Ay, Cx, Cy = line[0]
            cv2.line(self.img_draw, (Ax+leftArea[0][0], Ay+leftArea[0][1]), (Cx+leftArea[0][0], Cy+leftArea[0][1]), (0, 0, 255), 1)
            # 某一条线段的倾斜角度
            sitaCAB = -math.atan((Cy - Ay) / (Cx - Ax))
            # 累加成平均值
            self.avg_sitaCAB = self.avg_sitaCAB + sitaCAB / num
        # 弧度制转化为角度制
        self.avg_sitaCAB = self.avg_sitaCAB / math.pi * 180
        # print("左衔铁角度为:{}".format(self.avg_sitaCAB))
        # cv2.imshow("line_detect_possible_demo", self.img_draw)
        # cv2.waitKey(0)


    #此函数与line_detect_Left功能相同，是检测右侧的衔铁角度函数
    def line_detect_Right(self, rightArea):
        # image为裁剪后的右衔铁图像
        image = self.src[rightArea[0][1]:rightArea[1][1], rightArea[0][0]:rightArea[1][0]]
        image = cv2.medianBlur(image, 3)  # 中值滤波
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        edges = cv2.Canny(gray, 50, 150, apertureSize=3)
        # cv2.imshow("right_edge", edges)
        # cv2.waitKey(0)
        self.right_lines = cv2.HoughLinesP(edges, 1, np.pi / 1800, 100, minLineLength=90, maxLineGap=10)
        self.avg_sitaCB_Infinity = 0
        num = np.size(self.right_lines, 0)
        for line in self.right_lines:
            Cx, Cy, Bx, By = line[0]
            cv2.line(self.img_draw, (Bx+rightArea[0][0], By+rightArea[0][1]), (Cx+rightArea[0][0], Cy+rightArea[0][1]), (0, 0, 255), 1)
            sitaCB_Infinity = -math.atan((Cy - By) / (Cx - Bx))
            self.avg_sitaCB_Infinity = self.avg_sitaCB_Infinity + sitaCB_Infinity / num

        self.avg_sitaCB_Infinity = 180 + self.avg_sitaCB_Infinity / math.pi * 180
        # print("右衔铁角度为:{}".format(self.avg_sitaCB_Infinity))
        # print("衔铁角度为:{}".format(self.avg_sitaCB_Infinity - self.avg_sitaCAB))
        # cv2.imshow("final_show", self.img_draw)
        # cv2.waitKey(0)

    
    # 计算最终衔铁角度，四舍五入保留四位小数
    def angel(self):
        self.angle_show = round(self.avg_sitaCB_Infinity - self.avg_sitaCAB, 4)









# 程序框架
# 两个文本框(l,l_result)与两个按钮(b_select,b_run)共同处于一个容器中，显示布片的画布在第二容器中。
# 第一容器在程序第一行，第二容器在第二行
class App:
    def __init__(self,window, window_title):
        # 窗口初始化
        self.window = window
        self.window.title(window_title)
        self.window.geometry('1280x1200')

        # 显示的内容
        self.var = tk.StringVar()
        self.var.set('请载入图片！')
        self.var_result = tk.StringVar()
        self.var_result.set('结果:   ')

        # 创建容器
        self.frame1 = tk.Frame(window)

        # 显示的窗口
        l = tk.Label(self.frame1, textvariable=self.var, bg='white', font=('Arial', 12), width=15,
                     height=2)
        l.grid(row=0, column=2)
        l_result = tk.Label(self.frame1, textvariable=self.var_result, bg='white', font=('Arial', 12), width=15,
                     height=2)
        l_result.grid(row=0, column=3)
        # 初始化画布
        # canvas for image
        self.canvas = tk.Canvas(self.window, width=1280, height=1024)

        # images
        self.my_images = []
        self.my_image_number = -1
        self.image_on_canvas = self.canvas.create_image(0, 0, anchor=tk.NW, image=None)
        self.canvas.grid(row=1, column=0)

        # 按钮
        b_select = tk.Button(self.frame1, text='选择图片', width=15,
                             height=2, command=self.select)
        b_select.grid(row=0, column=0)

        b_run = tk.Button(self.frame1, text='运行', width=15,
                             height=2, command=self.run)
        b_run.grid(row=0, column=1)

        self.frame1.grid(row=0, column=0)
        # 主循环
        self.window.mainloop()

    # 点击"选择图片"按钮，执行以下函数。读取文件地址，载入图片
    def select(self):
        file_path = filedialog.askopenfilename()
        self.src = cv2.imread(file_path)
        self.var.set('已载入！')

     # 点击"运行"按钮，执行以下函数。处理图像并在画布上显示结果图像
    def run(self):
        # 实例化对象
        angularclac = AngularCalc(self.src)
        # 计算左右衔铁的位置(定位)
        leftArea = angularclac.template_left(self.src)
        rightArea = angularclac.template_right(self.src)
        # 左右衔铁倾斜角度计算
        angularclac.line_detect_Left(leftArea)
        angularclac.line_detect_Right(rightArea)
        # 计算衔铁夹角
        angularclac.angel()

        # self.src = cv2.imread('./photo/14012573.bmp')
        # Get the image dimensions (OpenCV stores image data as NumPy ndarray)
        self.height, self.width, no_channels = angularclac.img_draw.shape

        # Create a canvas that can fit the above image
        # self.canvas = tk.Canvas(self.window, width=self.width, height=self.height)
        # 图像画布容器在整个界面的第二行
        self.canvas.grid(row=1, column=0)
        # 每点击一次，图片数组索引加一，以获取最新加入的图片
        self.my_image_number += 1
        # Use PIL (Pillow) to convert the NumPy ndarray to a PhotoImage
        self.photo = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(angularclac.img_draw))
        # 将转换后的图片放入self.my_images图片数组中
        self.my_images.append(self.photo)
        # 更新画布信息，以显示图像
        self.canvas.itemconfig(self.image_on_canvas, image = self.my_images[self.my_image_number])
        # 显示角度值
        self.var.set("角度为: " + str(angularclac.angle_show))
        # 判断衔铁夹角是否满足规格
        if abs(angularclac.angle_show-90) <= 3:
            self.var_result.set("结果:合格")
        else:
            self.var_result.set("结果:不合格")


    #
    # def img_dealing(self):
    #     src = cv2.imread('./photo/14012573.bmp')
    #     print(src.shape)
    #     # 实例化对象
    #     angularclac = AngularCalc(src)
    #     # 计算衔铁位置
    #     leftArea = angularclac.template_left(src)
    #     rightArea = angularclac.template_right(src)
    #     # 角度计算（目标图像预处理）
    #     angularclac.line_detect_Left(leftArea)
    #     angularclac.line_detect_Right(rightArea)
    #     angularclac.angel()
    #     print(leftArea)
    #     print(rightArea)

# 主函数
if __name__ == '__main__':
    App(tk.Tk(), "衔铁角度提取软件")



