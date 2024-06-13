# Exploring Open World Object Detection on Autonomous Driving Image Data
### Evaluating and Enhancing the Performance of a Transformer Based OWOD Method on the Zenseact Open Dataset 

This is the code used in our master thesis project. The project builds on the official codebase for the PROB Open World Object Detection method called PROB: https://github.com/orrzohar/PROB

### Abstract
Open world object detection (OWOD) enhances traditional object detection by not only recognizing classes it was trained on but also identifying novel classes as ’unknown’, while also incrementally learning these new classes. Since OWOD was introduced in 2021, various methods have been developed, typically trained and evaluated using benchmark datasets like MS-COCO. In this thesis, we examine the performance of one of the stateof-the-art OWOD methods, PROB, in a new context by applying it to the autonomous driving dataset, Zenseact Open Dataset (ZOD), and explore various strategies to enhance its performance. To evaluate the performance, we apply a standard framework in OWOD, looking at wilderness impact (WI), absolute open set error (A-OSE) and unknown recall (U-recall) for the unknown classes and mean average precision (mAP) for the known classes. Our results demonstrate that PROB exhibits inferior performance across all metrics on ZOD compared to benchmark datasets. Modifications to the initial method revealed that tuning the objectness temperature was unnecessary, while adjusting the class distributions for more even representation improved performance for less common classes. The most significant performance improvement was observed when incorporating curriculum learning, which involves changing the training structure by starting with easier training examples and gradually progressing to more difficult ones. However, neither of these improved methods reach the performance of PROB when applied to benchmark datasets, which can primarily be attributed to ZOD being a very different and challenging dataset. These findings underscore the difficulty of applying OWOD methods to diverse real-world datasets and highlight the need for further research to develop more robust and adaptable detection models.

