import numpy as np
import cv2
import sys
from time import time

import kcftracker

num_objects = 1
selectingObject = [False] * num_objects
initTracking = False
onTracking = False

ix, iy, cx, cy = -1, -1, -1, -1
w, h = 0, 0

inteval = 1
duration = 0.01
counter = 0
initbb = []
color = [(0, 255, 255), (255, 0, 255), (255, 255, 0)]

"""
flag = 1 : marks dynamic reading (from camera)
flag = 2 : marks static reading  (from sequence or video)
"""

def draw_multi_boundingbox(event, x, y, flags, param):
	global selectingObject, initTracking, onTracking, ix, iy, cx,cy, w, h, num_objects, counter

	if event == cv2.EVENT_LBUTTONDOWN:
		selectingObject[counter] = True
		onTracking = False
		ix, iy = x, y
		cx, cy = x, y

	elif event == cv2.EVENT_MOUSEMOVE:
		cx, cy = x, y

	elif event == cv2.EVENT_LBUTTONUP:
		selectingObject[counter] = False
		if(abs(x-ix)>10 and abs(y-iy)>10):
			w, h = abs(x - ix), abs(y - iy)
			ix, iy = min(x, ix), min(y, iy)
			if (counter <= num_objects):
				counter += 1
				selectingObject[num_objects-counter] = True
			if (counter == num_objects):
				initTracking = True
		else:
			onTracking = False

	elif event == cv2.EVENT_RBUTTONDOWN:
		onTracking = False
		if(w>0):
			ix, iy = x-w/2, y-h/2
			initTracking = True

if __name__ == '__main__':
	flag = 0
	num_objects = input('Enter the number of objects: ')
	selectingObject = [False] * num_objects
	if(len(sys.argv) == 1):
		cap = cv2.VideoCapture(0)
		flag = 1
	elif(len(sys.argv) == 3):
		## setting external camera
		if (sys.argv[1].isdigit() and sys.argv[2] == 'cam'):
			cap = cv2.VideoCapture(sys.argv[1])
			flag = 1
		elif (sys.argv[2] == 'vid'):
			cap = cv2.VideoCapture(sys.argv[1])
			flag = 2
		elif (sys.argv[2] == 'seq'):
			cap = cv2.VideoCapture(sys.argv[1] + '%04d.jpg', cv2.CAP_IMAGES)
			flag = 2
			inteval = 30
	else:
		assert(0), "Please check help for description"

	tracker = [kcftracker.KCFTracker(True, True, True)] * num_objects
	# hog, fixed_window, multiscale

	cv2.namedWindow('Tracking')
	cv2.setMouseCallback('Tracking',draw_multi_boundingbox)

	# Reading the first frame in case of stored video
	# This ensures we can mark the BB with stability.
	ret, frame = cap.read()
	if not ret:
		print('Nothing was returned.')
		exit(0)
	firstFrame = frame.copy() # Copy to restore each frame after BB creation
	while (not initTracking and flag == 2):
		for i in range(num_objects):
		if np.all(selectingObject):
			cv2.rectangle(frame, (ix,iy), (cx,cy), (0,255,255), 1)
			initbb.append([ix, iy, w, h])
		cv2.imshow('Tracking', frame)
		cv2.waitKey(inteval)
		frame = firstFrame.copy() # Duplicate into frame the non BB overlay frame
	# Reading the subsequent frames in case of both camera & stored video
	print( '#BBs: {}'.format(len(initbb)) )
	while(cap.isOpened()):
		ret, frame = cap.read()
		if not ret:
			break
		if flag == 1 and np.all(selectingObject):
		 	cv2.rectangle(frame,(ix,iy), (cx,cy), (0,255,255), 1)
			initbb.append([ix, iy, w, h])
		elif(initTracking):
			cv2.rectangle(frame,(ix,iy), (ix+w,iy+h), (0,255,255), 2)
			for i in range(num_objects):
				tracker[i].init(initbb[i], frame)
			initTracking = False
			onTracking = True
		elif(onTracking):
			for i in range(num_objects):
				t0[i] = time()
				bb[i] = tracker[i].update(frame)
				t1[i] = time()
				bb[i] = map(int, bb[i])
				cv2.rectangle(frame,(bb[i][0],bb[i][1]), (bb[i][0]+bb[i][2],bb[i][1]+bb[i][3]), color[i], 1)
				duration = 0.8*duration + 0.2*(t1-t0)
			#duration = t1-t0
				cv2.putText(frame, 'FPS: '+str(1/duration)[:4].strip('.'), (8,20), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color[i], 2)
			cv2.putText(frame, 'Amplitude: '+ str(amplitude), (8,40), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color[i], 2)
		cv2.imshow('Tracking', frame)
		# Exit on key 'esc' or 'q'
		c = cv2.waitKey(inteval) & 0xFF
		if c==27 or c==ord('q'):
			break

	cap.release()
	cv2.destroyAllWindows()
