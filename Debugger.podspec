#
# Be sure to run `pod lib lint Debugger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Debugger'
  s.version          = '0.1.0'
  s.summary          = 'With good tools, it\'s easier and faster to code and debug. Here are some of those which I\'m developing. They help or will help me out on my projects.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
With good tools, it's easier and faster to code and debug. Here are some of those which I'm developing. They help or will help me out on my projects.
                       DESC

  s.homepage         = 'https://github.com/claudiomadureira/swift-debugger'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'claudiomadureira' => 'claudiomsilvaf@gmail.com' }
  s.source           = { :git => 'https://github.com/claudiomadureira/swift-debugger.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  
  s.dependency 'SwiftArsenal', '0.1.1'
  
  s.source_files = 'Debugger/Classes/**/*'
  s.resource_bundles = {
    'Debugger' => ['Debugger/Assets/*.{xcassets,png}']
  }

end
