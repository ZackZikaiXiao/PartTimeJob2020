import tkinter
import cv2
import PIL.Image, PIL.ImageTk
import time

class App:
    def __init__(self, window, window_title):
        self.window = window
        self.window.title(window_title)

        # open video source (by default this will try to open the computer webcam)
        self.vid = MyVideoCapture('smog.mp4')

        # Create a canvas that can fit the above video source size
        self.canvas = tkinter.Canvas(window, width=self.vid.width, height=self.vid.height)
        self.canvas.pack()

        # Button that lets the user take a snapshot

        # After it is called once, the update method will be automatically called every delay milliseconds
        self.delay = 25
        self.update()

        self.window.mainloop()


    def update(self):
        # Get a frame from the video source
        ret, frame = self.vid.get_frame()
        if ret:
            self.photo_video = PIL.ImageTk.PhotoImage(image = PIL.Image.fromarray(frame))
            self.canvas.create_image(0, 0, image=self.photo_video, anchor=tkinter.NW)

        self.window.after(self.delay, self.update)


class MyVideoCapture:
    def __init__(self, path):
        # Open the video source
        self.vid = cv2.VideoCapture(path)
        # Get video source width and height
        self.width = self.vid.get(cv2.CAP_PROP_FRAME_WIDTH)
        self.height = self.vid.get(cv2.CAP_PROP_FRAME_HEIGHT)

    def get_frame(self):
        ret, frame = self.vid.read()
        if ret:
            # Return a boolean success flag and the current frame converted to BGR
            return (ret, cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
        else:
            return (ret, None)



# Create a window and pass it to the Application object
App(tkinter.Tk(), "Tkinter and OpenCV")