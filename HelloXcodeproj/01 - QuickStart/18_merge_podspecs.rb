
require 'cocoapods'
require_relative '../02 - Ruby Helper/rubyscript_helper'
require '../01 - QuickStart/18_podspec_reader'
require 'pp'

def test_simple_podspec
  podspec = PodspecReader::from_file('./18_simple.podspec', nil)
  dump_object(podspec)
  dump_object(podspec.attributes_hash)
  dump_object(podspec.subspecs)
end

def test_WangXinKit_podspec
  podspec = PodspecReader::from_file('./18_WangXinKit.podspec', nil)
  # dump_object(podspec.attributes_hash)
  puts podspec.to_pretty_json
end

def test_simple_WangXinKit_podspec
  podspec = PodspecReader::from_file('./18_simple_WangXinKit.podspec', nil)
  dump_object(podspec)
  dump_object(podspec.attributes_hash)
  dump_object(podspec.subspecs)
  podspec.subspecs.each do |spec|
    dump_object(spec.attributes_hash)
  end
end

def test_simple_simple_WXOpenIMSDK_Dynamic_podspec
  podspec = PodspecReader::from_file('./18_simple_WXOpenIMSDK_Dynamic.podspec', nil)
  dump_object(podspec)
  dump_object(podspec.attributes_hash)
  dump_object(podspec.subspecs)
end



def test_merge_subspec()

  podspecs = []

  arr = './18_simple_WangXinKit.podspec', './18_simple_WXOpenIMSDK_Dynamic.podspec'
  arr.each do |item|
    spec = PodspecReader::from_file(item, nil)
    podspecs.push(spec)
  end

  all_subspecs = PodspecReader::merge_subspec(podspecs)

end

def test_merge_podspecs
  arr = './18_simple_WangXinKit.podspec', './18_simple_WXOpenIMSDK_Dynamic.podspec'
  # arr = './18_WangXinKit.podspec', './18_WXOpenIMSDK_Dynamic.podspec'
  current_dir = File.expand_path('..', __FILE__)
  podspec_name = 'WXOpenIMSDKStatic'
  force_attributes = {
      'homepage' => 'http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk/',
      'license' => 'MIT',
      'platforms' => { 'ios' => '5.0' },
      'requires_arc' => true,
      'source' => { :git => 'https://url.git', :branch => 'master' }
  }
  PodspecReader.create_podspec_json(podspec_name, current_dir, arr, force_attributes)

end

###############################
# Test Methods


# test_simple_podspec
# test_WangXinKit_podspec
# test_simple_WangXinKit_podspec
# test_merge_subspec
test_merge_podspecs




