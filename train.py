import cv2
import tensorflow as tf

def train(args):
    # for CUDA GPU environment
    os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
    os.environ["CUDA_VISIBLE_DEVICES"] = args.dev

    #todo: manage parameters in main
    if args.data == "big":
        dataset_path = "/cvgl/group/GazeCapture/gazecapture"
    if args.data == "small":
        dataset_path = "/cvgl/group/GazeCapture/eye_tracker_train_and_val.npz"

    if args.data == "big":
        train_path = "/cvgl/group/GazeCapture/train"
        val_path = "/cvgl/group/GazeCapture/validation"
        test_path = "/cvgl/group/GazeCapture/test"

    print("{} dataset: {}".format(args.data, dataset_path))

    # train parameters
    n_epoch = args.max_epoch
    batch_size = args.batch_size
    patience = args.patience
