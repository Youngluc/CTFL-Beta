import cv2 as cv
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import wiener
# 读取图片
img = cv.imread('./eval/14dB/CW/0001.png')
source = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

lenaWiener = wiener(source, [3, 3])
lenaWiener = np.uint8(lenaWiener / lenaWiener.max() * 255)

plt.figure('经过维纳滤波后的图像')
plt.imshow(lenaWiener, cmap='gray')
plt.show()
