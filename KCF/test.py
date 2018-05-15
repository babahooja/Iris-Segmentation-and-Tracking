import cv2

cap = cv2.VideoCapture('../datasets/' + 'test' + '/%03d.jpeg', cv2.CAP_IMAGES)
inteval = 50000

cv2.namedWindow('sample', cv2.WINDOW_NORMAL)
cv2.resizeWindow('sample', 518, 345)
while(cap.isOpened()):
    ret, frame = cap.read()
    if not ret:
        break
    h = int(frame.shape[0]*0.1) # scale h
    w = int(frame.shape[1]*0.1) # scale w
    rsz_image = cv2.resize(frame, (w, h))
    # cv2.resizeWindow('sample', 518, 345)
    cv2.imshow('sample', rsz_image)

    c = cv2.waitKey(inteval) & 0xFF
    if c==27 or c==ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
