// This let variable not export to JSContext, but still can be used in JS code
let globalMessage = 'globalMessage';
console.log(globalMessage);

;(function() {
  // 测试console.log函数
  let message = "Hello, world!";
  console.log(message);
})();
