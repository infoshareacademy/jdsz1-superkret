import os
import numpy as np
import cv2
from keras import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, BatchNormalization, Activation
from keras.utils import np_utils, Sequence
from keras import regularizers
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard



TRAIN_LABELS_FILE = r"/home/kursant/deep learning/2018_07_21/datasets/dresses/train/labels.txt"
VAL_LABELS_FILE= r"/home/kursant/deep learning/2018_07_21/datasets/dresses/val/labels.txt"
TEST_LABELS_FILE = r"/home/kursant/deep learning/2018_07_21/datasets/dresses/test/labels.txt"


class MyGenerator(Sequence):


    def __init__(self, labels_path, batch_size):
        self.batch_size = batch_size
        self.dirname = os.path.dirname(labels_path)
        self.labels = self.read_labels(labels_path)
        self.indexes = np.arange(len(self.labels))

    def read_labels(self, path):
        with open(path) as f:
            labels = f.read().splitlines()
        return labels

    def get_data(self, indexes):
        x = []
        y = []

        for i in indexes:
            line = self.labels[i]
            #rozbij linijkna sciezke i etykiete
            path, label = line.split(maxsplit=1)
            # utworz absolutna sciezke
            path = os.path.join(self.dirname, path)
            #zaladuj obraz
            img = cv2.imread(path)
            #zmien rozmiar obrazu na 128 x 128
            img = cv2.resize(img, (128, 128), interpolation=cv2.INTER_AREA)
            #dodaj obraz do listy
            x.append(img)

            label_list = label.split()
            label_list_int = list(map(int, label_list))
            label = np.array(label_list_int)
            y.append(label)

        return np.array(x), np.array(y)



    def __getitem__(self, index):
        indexes = self.indexes[index * self.batch_size:(index +1)* self.batch_size]
        x,y = self.get_data(indexes)
        return x,y

    def __len__(self):
        return int(np.floor(len(self.labels) / self.batch_size))



def create_dataset(lines, dirname):
    images = []
    labels = []

    #dirname = os.path.dirname(linepath)
    for line in lines:
        path, label = line.split(maxsplit=1)
        path = os.path.join(dirname, path)
        img = cv2.imread(path)
        img = cv2.resize(img, (128, 128), interpolation=cv2.INTER_AREA)
        images.append(img)

        label_list = label.split()
        label_list_int = list(map(int, label_list))
        label = np.array(label_list_int)
        #label = np_utils.to_categorical(label, 14)
        labels.append(label)

    return np.array(images), np.array(labels)


def show_dataset(images, labels):
    for img, l in zip(images, labels):
        print(l)
        cv2.imshow("image", img)
        cv2.waitKey()

def create_model():
    model = Sequential()
    model.add(Conv2D(16, (3, 3), input_shape=(128, 128, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))

    model.add(Conv2D(16, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))

    model.add(MaxPooling2D((2,2)))
    model.add(Conv2D(32, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))

    model.add(Conv2D(32, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))

    model.add(MaxPooling2D((2, 2)))
    model.add(Flatten())
    model.add(Dense(128, kernel_regularizer=regularizers.l2(0.01)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(Dense(14, activation="sigmoid"))
    model.compile(optimizer="Adam", loss="binary_crossentropy", metrics=["categorical_accuracy"])
    model.load_weights("weights.hdf5")

    return model

def get_callbacks():
    callbacks = []

    mc = ModelCheckpoint("weights.hdf5", monitor="val_loss", save_best_only=True, verbose=1)
    es = EarlyStopping(monitor="val_loss", patience=3, verbose=1)
    tb = TensorBoard(log_dir='./logs', histogram_freq=0, batch_size=32, write_graph=True, write_grads=False,
                                write_images=False, embeddings_freq=0, embeddings_layer_names=None,
                                embeddings_metadata=None, embeddings_data=None)
    callbacks.append(mc)
    callbacks.append(es)
    callbacks.append(tb)

    return callbacks

def main():
    # lines_train = read_labels(TRAIN_LABELS, 50)
    # lines_val = read_labels(VAL_LABELS, 50)
    # images_train, labels_train = create_dataset(lines_train, os.path.dirname(FILE_TRAIN))
    # images_val, labels_val = create_dataset(lines_val, os.path.dirname(FILE_VAL))

    # Parameters
    # params = {'dim': (50, 14),
    #           'batch_size': 10,
    #           'n_classes': 14,
    #           'n_channels': 1,
    #           'shuffle': True}

    training_generator = MyGenerator(TRAIN_LABELS_FILE, 50)
    validation_generator = MyGenerator(VAL_LABELS_FILE, 50)
    test_generator = MyGenerator(VAL_LABELS_FILE, 50)

    model = create_model()
    #model.compile(optimizer="sgd", loss="categorical_crossentropy")
    #model.compile(optimizer="Adam", loss="binary_crossentropy", metrics=["categorical_accuracy"])
    #model.compile(optimizer="sgd", loss="MSE")
    #model.compile(optimizer="Adam", loss="MSE")

    callbacks = get_callbacks()

    model.summary()



    #model.fit(images_train, labels_train, batch_size = 10, epochs = 100, validation_data=(images_val, labels_val), verbose=1, callbacks=callbacks)
    model.fit_generator(generator=training_generator,
                        epochs=10,
                        validation_data=validation_generator,
                        use_multiprocessing=True,
                        callbacks=callbacks)

    scoreSeg = model.evaluate_generator(test_generator)
    print("Accuracy on test dataset= ", scoreSeg[1])

    #model.predict_generator(generator=test_generator, use_multiprocessing=True)
    #scoreTest = model.predict_generator(generator=test_generator, use_multiprocessing=True)
    #print("Accuracy on test dataset = ", scoreTest[1])


    #show_dataset(images, labels)


if __name__ == '__main__':
    main()
