# HelloCocoaPods-StaticLibraryIntegration
--

TOC

## 1. 


## 2. CocoaPods Hook



```
$ pod plugins installed

Installed CocoaPods Plugins:
    - cocoapods-deintegrate   : 1.0.1
    - cocoapods-packager      : 1.5.0
    - cocoapods-plugins       : 1.0.0
    - cocoapods-repo-alirsync : 1.0.9
    - cocoapods-repo-rsync    : 1.0.6 (source_provider hook)
    - cocoapods-search        : 1.0.0
    - cocoapods-stats         : 1.0.0 (post_install hook)
    - cocoapods-trunk         : 1.3.0
    - cocoapods-try           : 1.1.0
```

可以从Pod::HooksManager::registrations获取已经注册hook的plugin。

使用post_install去hook，如下

```ruby
post_install do |installer|
  puts 'post_install'
end
```

但是上面的hook，还在完成生成Pods.xcodeproj文件之前，可以用于设置一些build settings，但是不能使用xcodeproj工具

```
Generating Pods project
post_install
Integrating client project
```


