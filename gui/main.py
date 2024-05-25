import os
import sys
import numpy as np
import tensorflow as tf

from PIL import Image
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import Slot, QObject


class NetBackend(QObject):
    def __init__(self) -> None:
        super().__init__()
        self.plants_model = tf.keras.models.load_model('trees_and_plants.h5')
        self.plants_classes = os.listdir("dataset")

    @Slot(str, result=str)
    def predict(self, filepath: str):
        _fp = filepath[8:].replace('/', '\\')
        image = Image.open(_fp).convert('RGB')
        image_array = np.array(image.resize((416, 315)))
        preds = self.plants_model.predict(np.expand_dims(image_array, axis=0))
        _id = preds.argmax()
        _name = self.plants_classes[_id]
        _res = int(preds.max() * 100)
        return f"{_name}: {_res}%"


app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('gui/main.qml')

net = NetBackend()
context = engine.rootContext()
context.setContextProperty("net", net)

sys.exit(app.exec_())

