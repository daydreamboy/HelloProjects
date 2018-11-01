$developing_pods = {}
developing_pods_config_file = 'developing_pods.json'
if File.exists?(developing_pods_config_file) then
  $developing_pods = JSON.parse(IO.read developing_pods_config_file)
end

# 重定义 pod, 如果是本地开发的则用本地，反之用共有的
alias old_pod pod
def pod(*args)
  pod_name = args[0]
  path = $developing_pods[pod_name]
  if path then
    puts "\033[32musing developing pod #{pod_name}\033[0m"
    old_pod pod_name, :path => path
  else
    old_pod *args
  end
end