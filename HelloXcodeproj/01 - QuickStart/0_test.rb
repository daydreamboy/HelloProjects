require_relative '../02 - Ruby Helper/rubyscript_helper'

string = "cntaobaotb405932903_0,cntaobaomayanszoo_0,cntaobao阿mei子_0,cntaobao零点玖266_0,cntaobao王明玉1225_0,cntaobao黑色幽默的菜鸟_0,cntaobaotb4554654_0,chntribe1527835277_1730,cntaobao晨凉_0,cntaobaolulu7772118_0,cntaobaopangyanqing燕_0,cntaobao严yxj0216_0,cntaobao黄煌伟hhw_0,cntaobao599043708luo_0,cntaobao半匙水_0,cntaobao徐闲群和_0,cntaobao风清扬夏未央6624_0,cntaobao夜明珠壹加壹_0,cntaobaoplaaaaaa_0,cntaobao糖宝姐姐0852123_0,cntaobao小俊957693016_0,cntaobao非梨花倾香_0,cntaobao我是牛牛aa_0,cntaobaotb7719813_2013_0,cntaobao阿宇0505_0,cntaobao硕姐无敌_0,cntaobao13820515089赵倩_0,cntaobaotb_9893973_0,cntaobao某黑马甲_0,cntaobao学淘去_0,cntaobao青铜峡8_0,cntaobao镁浈6868_0,cntaobao友谊无价，_0,cntaobaoww936456572_0,cntaobao指尖上0的温柔_0,cntaobaosty971117_0,cntaobao孙国财26_0,cntaobao左国强19870608_0,cntaobao明明白白weichao_0,cntaobao繁花落尽的霓虹_0,cntaobao风落琉璃瓦_0,cntaobaoi倾城bb_0,cntaobao刘智芳4825_0,cntaobao海澜之家直属仓库珊珊_0,cntaobao两年无悔军旅_0,cntaobao权志龙大福_0,cntaobao郭霞1223_0,chntribe1869144725_529,cntaobaot_1514460232961_0814_0,cntaobaolzqmmnn2011_0,cntaobaohhl526312519_0,cntaobao你长的真奇妙阿_0,cntaobao2389503602一切的一切_0,cntaobao木子门虫水函_0,cntaobao莫尘傲霜_0,cntaobao刘斯琪40510797_0,cntaobao52113148媛宝宝_0,cntaobaotb37990568_0,cntaobaotb556719313_0,cntaobao美美倾心_0"
# puts string.split(',').count

user_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => %W[
      $(inherited)
      ${PODS_ROOT}/Headers/Public/MPMessageContainer/MCTree
      ${PODS_ROOT}/Headers/Public/MPMessageContainer/MPDynamicCard
      ${PODS_ROOT}/Headers/Public/MPMessageContainer/MPMUIComponent
      ${PODS_ROOT}/Headers/Public/MPMessageContainer/MPUIKit
      ].join(' ')
}
puts user_target_xcconfig