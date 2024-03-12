#!/bin/bash

conda activate prob

mkdir data/OWOD/JPEGImages/

mkdir data/OWOD/Annotations/

mkdir data/coco/

wget http://images.cocodataset.org/zips/train2017.zip -P data/coco

wget http://images.cocodataset.org/zips/val2017.zip -P data/coco

wget http://images.cocodataset.org/zips/test2017.zip -P data/coco

wget http://images.cocodataset.org/annotations/annotations_trainval2017.zip -P data/coco

unzip data/coco/train2017

unzip data/coco/val2017

unzip data/coco/test2017

unzip data/coco/annotations_trainval2017.zip

ls -1 train2017/ | xargs -i mv train2017/{} data/OWOD/JPEGImages/

ls -1 val2017/ | xargs -i mv val2017/{} data/OWOD/JPEGImages/

ls -1 test2017/ | xargs -i mv test2017/{} data/OWOD/JPEGImages/

cp -r annotations data/coco

python datasets/coco2voc.py

wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar

wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar

wget http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar

tar -xf VOCtrainval_06-Nov-2007.tar

tar -xf VOCtest_06-Nov-2007.tar

tar -xf VOCtrainval_11-May-2012.tar

ls -1 VOCdevkit/VOC2012/Annotations/ | xargs -i mv VOCdevkit/VOC2012/Annotations/{} data/OWOD/Annotations/

ls -1 VOCdevkit/VOC2012/JPEGImages/ | xargs -i mv VOCdevkit/VOC2012/JPEGImages/{} data/OWOD/JPEGImages/

ls -1 VOCdevkit/VOC2007/JPEGImages/ | xargs -i mv VOCdevkit/VOC2007/JPEGImages/{} data/OWOD/JPEGImages/

ls -1 VOCdevkit/VOC2007/Annotations/ | xargs -i mv VOCdevkit/VOC2007/Annotations/{} data/OWOD/Annotations/
