# HelloCoreDataWithCocoaPods
--

### 1. Integrated as Framework

Pod作为framework集成，xcdatamodeld文件可以指定在`resource_bundles`或`resource`中，但是两者有一些区别。

* `resource_bundles`，不支持xcdatamodeld文件的Codegen中的<b>Class Definition</b>和<b>Category/Extension</b>方式，只能使用<b>Manual/None</b>方式。
* `resource`，可以支持<b>Class Definition</b>和<b>Category/Extension</b>方式，同时也支持<b>Manual/None</b>方式。

推荐使用`resource_bundles`指定xcdatamodeld文件，结合<b>Manual/None</b>方式。


原因：resource_bundles对应的target的build phase中没有将xcdatamodeld文件放入Compile Sources中


### 2. Integrated as Static Library

