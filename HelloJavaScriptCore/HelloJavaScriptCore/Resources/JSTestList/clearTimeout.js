; (function () {
  // 测试setTimeout函数
  console.log("start");

  var timeoutID = setTimeout(() => {
    console.log("after 3s");
  }, 3000);

  console.log("end");

  clearTimeout(timeoutID);
})();
