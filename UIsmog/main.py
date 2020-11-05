from tkinter import filedialog
import tkinter as tk
import PIL.Image
import PIL.ImageTk
import cv2 as cv
import numpy as np


# 烟雾检测算法
def smog_check(image):
    kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]], np.float32)
    dst = cv.filter2D(image, -1, kernel=kernel)
    dst = cv.rectangle(dst, (70, 50), (250, 320), (255, 0, 0))

    # 烟雾判断标志
    check_flag = True # 有烟雾
    # dst是处理完之后要显示的图像，check_flag为是否有烟雾的标志
    return dst, check_flag


# 视频解析的类
class MyVideoCapture:
    def __init__(self, path):
        # Open the video source
        self.vid = cv.VideoCapture(path)
        # Get video source width and height
        self.width = self.vid.get(cv.CAP_PROP_FRAME_WIDTH)
        self.height = self.vid.get(cv.CAP_PROP_FRAME_HEIGHT)

    def get_frame(self):
        ret, frame = self.vid.read()
        if ret:
            # Return a boolean success flag and the current frame converted to BGR
            return (ret, cv.cvtColor(frame, cv.COLOR_BGR2RGB))
        else:
            return (ret, None)

# 主要类
class App:
    def __init__(self, window, window_title, width_stard):
        # 窗口初始化
        self.window = window
        self.window.title(window_title)
        self.window.geometry('1080x1920')

        # 显示的内容
        self.var = tk.StringVar()
        self.var.set('请载入图片！')
        self.var_result = tk.StringVar()
        self.var_result.set('检测结果:   ')

        # 创建容器
        self.frame1 = tk.Frame(window)  # 操作与显示容器
        self.frame2 = tk.Frame(window)  # 画布容器

        # 显示的窗口
        l = tk.Label(self.frame1, textvariable=self.var, bg='white', font=('Arial', 12), width=15,
                     height=2)
        l.grid(row=0, column=3)
        l_result = tk.Label(self.frame1, textvariable=self.var_result, bg='white', font=('Arial', 12), width=15,
                     height=2)
        l_result.grid(row=0, column=4)
        # 初始化画布
        # canvas for image
        self.width_stand = width_stard
        self.canvas_raw = tk.Canvas(self.frame2, width=self.width_stand, height=900)
        self.canvas_show = tk.Canvas(self.frame2, width=self.width_stand, height=900)

        # 视频容器
        self.img_video_list_raw = []
        self.img_video_list_show = []
        # 原始图像
        # 图像容器,以连续展示
        self.my_images_raw = []
        self.my_image_number_raw = -1
        self.image_on_canvas_raw = self.canvas_raw.create_image(0, 0, anchor=tk.NW, image=None)
        self.canvas_raw.grid(row=0, column=0)

        # 检测烟雾后的图像
        self.my_images_show = []
        self.my_image_number_show = -1
        self.image_on_canvas_show = self.canvas_show.create_image(0, 0, anchor=tk.NW, image=None)
        self.canvas_show.grid(row=0, column=1)

        # 选择图像则为0, 选择视频则为1
        self.img_video_flag  = 0
        # 按钮
        b_select_img = tk.Button(self.frame1, text='选择图片', width=15,
                             height=2, command=self.select_img)
        b_select_img.grid(row=0, column=0)

        b_select_video = tk.Button(self.frame1, text='选择视频', width=15,
                             height=2, command=self.select_video)
        b_select_video.grid(row=0, column=1)

        b_run = tk.Button(self.frame1, text='运行', width=15,
                             height=2, command=self.run)
        b_run.grid(row=0, column=2)

        self.frame1.grid(row=0, column=0)
        self.frame2.grid(row=1, column=0)
        # 主循环
        self.window.mainloop()


    def select_img(self):
        self.img_video_flag = 0
        # 载入图文件,提示框显示已载入
        file_path = filedialog.askopenfilename()
        self.src = cv.imread(file_path)
        self.var.set('已载入！')

        # 图像显示
        self.height, self.width, no_channels = self.src.shape

        # self.canvas = tk.Canvas(self.window, width=self.width, height=self.height)
        # 在规定位置显示
        self.canvas_raw.grid(row=0, column=0)
        self.my_image_number_raw += 1
        # Use PIL (Pillow) to convert the NumPy ndarray to a PhotoImage
        srcshow = self.src
        srcshow = cv.resize(srcshow, (int(self.height*self.width_stand/self.width), self.width_stand), interpolation=cv.INTER_CUBIC)
        self.photo = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(srcshow))

        self.my_images_raw.append(self.photo)
        self.canvas_raw.itemconfig(self.image_on_canvas_raw, image=self.my_images_raw[-1])

    def select_video(self):
        self.var.set('已载入！')
        self.img_video_flag = 1
        self.file_path = filedialog.askopenfilename()


    # 更新原视频
    def update_raw(self):
        # Get a frame from the video source
        ret, frame = self.vid.get_frame()
        if ret:
            frame = cv.resize(frame, (int(self.height * self.width_stand / self.width), self.width_stand), interpolation=cv.INTER_CUBIC)
            self.photo_video = PIL.ImageTk.PhotoImage(image = PIL.Image.fromarray(frame))
            self.canvas_raw.create_image(0, 0, image=self.photo_video, anchor=tk.NW)

        self.window.after(self.delay, self.update_raw)
    # 更新处理后的视频
    def update_show(self):
        # Get a frame from the video source
        ret, frame = self.vid.get_frame()
        if ret:
            frame, self.flagcheck = smog_check(frame)
            frame = cv.resize(frame, (int(self.height * self.width_stand / self.width), self.width_stand), interpolation=cv.INTER_CUBIC)
            self.photo_video_show = PIL.ImageTk.PhotoImage(image = PIL.Image.fromarray(frame))
            self.canvas_show.create_image(0, 0, image=self.photo_video_show, anchor=tk.NW)

        self.window.after(self.delay, self.update_show)

    # 主要运行文件
    def run(self):
        # 如果载入的是视频
        if self.img_video_flag == 1:
            self.vid = MyVideoCapture(self.file_path)
            self.vid_show = MyVideoCapture(self.file_path)
            self.height = self.vid.height
            self.width = self.vid.width
            self.canvas_raw = tk.Canvas(self.frame2, width=self.width_stand, height=int(self.height*self.width_stand/self.width))
            self.canvas_show = tk.Canvas(self.frame2, width=self.width_stand, height=int(self.height*self.width_stand/self.width))
            self.canvas_raw.grid(row=0, column=0)
            self.canvas_show.grid(row=0, column=1)
            self.delay = 50
            self.update_raw()
            self.update_show()
            if self.flagcheck == True:
                self.var_result.set("结果:检测到烟雾！")
            else:
                self.var_result.set("结果:未检测到烟雾！")
        # 如果载入的是图片
        else:
            ###############处理后图片##############
            self.img_show, self.flagcheck = smog_check(self.src) # 从原始图像中拿一张
            self.canvas_show.grid(row=0, column=1)
            self.img_show, self.flagcheck = smog_check(self.img_show)                   # 算法处理
            self.img_show = cv.resize(self.img_show, (int(self.height * self.width_stand / self.width), self.width_stand), interpolation=cv.INTER_CUBIC)  # 尺度变换
            self.photo_show = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(self.img_show))  # 转换为可显示图片
            self.my_images_show.append(self.photo_show)                 #添加到显示列表
            self.canvas_show.itemconfig(self.image_on_canvas_show, image=self.my_images_show[-1])

            if self.flagcheck == True:
                self.var_result.set("结果:检测到烟雾！")
            else:
                self.var_result.set("结果:未检测到烟雾！")



if __name__ == '__main__':
    App(tk.Tk(), "基于视觉的机舱烟雾监测系统", 960)



