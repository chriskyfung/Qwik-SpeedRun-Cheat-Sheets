# GSP141 Creating an Object Detection Application Using TensorFlow

_last update: 2021-04-25_

Launch a VM instance

SSH

```bash
sudo -i

apt-get update
apt-get install -y protobuf-compiler python3-pil python3-lxml python3-pip python3-dev git
```

```bash
pip3 install Flask==1.1.1 WTForms==2.2.1 Flask_WTF==0.14.2 Werkzeug==0.16.0
```

```bash
pip3 install tensorflow==2.0.0b1 -y

```

```bash
cd /opt
git clone https://github.com/tensorflow/models
cd models/research
protoc object_detection/protos/*.proto --python_out=.

mkdir -p /opt/graph_def
cd /tmp
for model in \
  ssd_mobilenet_v1_coco_11_06_2017 \
  ssd_inception_v2_coco_11_06_2017 \
  rfcn_resnet101_coco_11_06_2017 \
  faster_rcnn_resnet101_coco_11_06_2017 \
  faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017
do \
  curl -OL http://download.tensorflow.org/models/object_detection/$model.tar.gz
  tar -xzf $model.tar.gz $model/frozen_inference_graph.pb
  cp -a $model /opt/graph_def/
done

ln -sf /opt/graph_def/faster_rcnn_resnet101_coco_11_06_2017/frozen_inference_graph.pb /opt/graph_def/frozen_inference_graph.pb

```

```bash
cd $HOME

git clone https://github.com/GoogleCloudPlatform/tensorflow-object-detection-example

cp -a tensorflow-object-detection-example/object_detection_app_p3 /opt/

chmod u+x /opt/object_detection_app_p3/app.py

cp /opt/object_detection_app_p3/object-detection.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable object-detection
systemctl start object-detection
systemctl status object-detection

```

Username - `username`
Password - `passw0rd`
