## AwesomeSDK

### podspec

AwesomeSDK提供两种podspec

* AwesomeSDK_development.podspec，支持源码集成
* AwesomeSDK_production.podspec，支持framework集成，framework放在Product文件夹下，使用Example工程来生成framework。

### 拷贝framework到Product文件夹

Example/Podfile

```
...
# Configurations
run_script_name = '[Podfile] Copy To Product Folder'
script_content = 'rsync -arv "${CONFIGURATION_BUILD_DIR}" "${PROJECT_DIR}/../../Product/"'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'AwesomeSDK'
      new_phase = target.new_shell_script_build_phase(run_script_name)
      new_phase.shell_script = script_content
    end
  end

  installer.pods_project.save(installer.pods_project.path)
end
```