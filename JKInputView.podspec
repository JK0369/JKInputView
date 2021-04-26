#
# Be sure to run `pod lib lint JKInputView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKInputView'
  s.version          = '0.1.4'
  s.summary          = 'password, phone number, email input text view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC 
password, phone number, email input text view.
how to use
 - enum type of IBInspector property exists range for 0~4.
                       DESC

  s.homepage         = 'https://github.com/JK0369/JKInputView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JK0369' => 'palatable7@naver.com' }
  s.source           = { :git => 'https://github.com/JK0369/JKInputView.git', :tag => s.version.to_s, :branch => "master" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'JKInputView/Classes/**/*'
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'JKInputView' => ['JKInputView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
