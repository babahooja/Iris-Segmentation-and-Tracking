import cv2
# import tensorflow as tf
import math
import numpy as np
from numpy import linalg as LA
import itertools
import skimage.transform ## for resizing

def resize(img, new_width=500):
    if(len(img.shape) > 2):
        h, w, c = img.shape
    else:
        h, w = img.shape
    # Check the changes with different interpolations!
    img = skimage.transform.resize(img, (new_width, (h*new_width)/w),)
    return img


def normalize(x, y, threshold = 0.0):
    mag = math.sqrt(x ** 2 + y ** 2)
    if mag > 0:
        return [x/mag, y/mag]
    else:
        return [0, 0]

def videoToFrames(path, savePath):
    pass

if __name__ == '__main__':
    dir = 'sample_images/'
    fileNames = [dir + 'eye0.jpg',]
    for fileName in fileNames:
        #load the image
        img = cv2.imread(fileName, 0)
        #resize the image
        img = resize(img, 40) # Setting the width to 20px
        h, w = img.shape

        # Calculating the sobel gradient in either direction

        sobel_x = cv2.Sobel(img, cv2.CV_16S, 1, 0, ksize = 3) #16 bit signed integers
        sobel_x = cv2.normalize(sobel_x, sobel_x, -127.0, 127.0, cv2.NORM_MINMAX, cv2.CV_8S)

        sobel_y = cv2.Sobel(img, cv2.CV_16S, 0, 1, ksize = 3)
        sobel_y = cv2.normalize(sobel_y, sobel_y, -127.0, 127.0, cv2.NORM_MINMAX, cv2.CV_8S)

        grad_x = []
        grad_y = []

        for (x_row, y_row) in itertools.izip(sobel_x, sobel_y):
            for (x, y) in itertools.izip(x_row, y_row):
                # normalize the gradient vector
                norm = normalize(x, y, threshold = 0)
                grad_x.append(norm[0])
                grad_y.append(norm[1])

        grad_x = np.reshape(np.array(grad_x, dtype = np.float16), (-1, w))
        grad_y = np.reshape(np.array(grad_y, dtype = np.float16), (-1, w))

        grad = np.dstack((grad_x, grad_y))

        # find the center
        max_dot_sum = -1

        # Timm Barth Approach:  Let c be a possible centre and gi, the gradient
        # vector at position xi. Then, the normalised displacement vector di
        # should have the same orientation (except for the sign) as the gradient gi
        for (center_r, center_c) in np.ndindex(h, w):
            dot_sum = 0
            for (grad_r, grad_c) in np.ndindex(h, w):
                disp = normalize(grad_r - center_r, grad_c - center_c)
                dot = disp[0] * grad_y[grad_r, grad_c] + disp[1] * grad_x[grad_r, grad_c]
                dot_sum += dot

            if dot_sum > max_dot_sum:
                max_dot_sum = dot_sum
                center = [center_c, center_r]

        cv2.circle(img, tuple(center), 1, 255, -1)
        cv2.imshow('img', img)
        cv2.waitKey(0)
        cv2.destroyAllWindows()







    # parser = argparse.ArgumentParser()
    # parser.add_argument('-train', action='store_true', help='train flag')
    # parser.add_argument('-dev', type=str, default="-1", help='what cpu or gpu (recommended) use to train the model')
    # parser.add_argument('-max_epoch', type=int)
    #
    # if args.train:
    #     train(args)
    #
    # cv2.imread('watch.jpg', 0)
