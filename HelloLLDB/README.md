## HelloLLDB

TOC


## Call Convention

#### x86_64

* RDI、RSI、RDX、RCX、R8、R9，存放方法（函数）的前6个参数，从第7个参数开始用栈来存放。
* RAX，存放方法（函数）的返回值

#### ARM64

* x0-x7，存放方法（函数）的前8个参数，具体个数视调试而定
* x0，存放方法（函数）的返回值