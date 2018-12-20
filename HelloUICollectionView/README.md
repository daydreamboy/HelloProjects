## HelloUICollectionView

[TOC]

---

### 1、Flow Layout

​       UICollectionView布局是Flow Layout（流式布局），放置item按照row（水平方向）或者column（垂直方向）的顺序。`UICollectionViewFlowLayout`类实现了这种方式，如果需要其他自定义功能则可以实现其子类。

​       UICollectionViewFlowLayout定义了两个方向，一个是固定距离的方向，一个是可以滚动的方向。官方文档描述，如下

> Flow layouts lay out their content using a fixed distance in one direction and a scrollable distance in the other.

​       UICollectionViewFlowLayout的`scrollDirection`属性定义可以滚动的方向，则和这个方向垂直的另一个方向则是固定距离的。例如`scrollDirection`属性值是UICollectionViewScrollDirectionVertical（默认值），则UICollectionView是竖直滚动（垂直方向）的，item按照row方式（水平方向）排列，如果一行放不满则换行。



#### （1）UICollectionViewFlowLayout的几个重要属性

| 属性名                  | 说明                                 |
| ----------------------- | ------------------------------------ |
| scrollDirection         | 定义滚动方向，也确定了固定距离方向。 |
| itemSize                |                                      |
| minimumLineSpacing      |                                      |
| minimumInteritemSpacing |                                      |





