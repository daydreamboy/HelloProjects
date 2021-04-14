



```
**2021-04-14 20:15:17.682282+0800 HelloMasonry[84621:656741] \**\* Assertion failure in -[MASViewConstraint install], MASViewConstraint.m:348**

**2021-04-14 20:15:17.733001+0800 HelloMasonry[84621:656741] \**\* Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'couldn't find a common superview for <UILabel: 0x7fdc8e108ca0; frame = (0 0; 0 0); text = 'Hello, world!'; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x60000247d310>> and <UIView: 0x7fdc8e105d70; frame = (0 0; 390 844); autoresize = W+H; layer = <CALayer: 0x60000077e1e0>>'**
```





layoutIfNeeded和setNeedsUpdateConstraints触发updateConstraints方法







