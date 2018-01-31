#
# Be sure to run `pod lib lint TYPageViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TYPageViewController'
  s.version          = '0.2.1'
  s.summary          = 'TYPageViewController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  多ScrollView 嵌套 悬停Header
                       DESC

  s.homepage         = 'https://github.com/sherlockmm/TYPageViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1130128166@qq.com' => 'wangzhiming@tuyabeat.com' }
  s.source           = { :git => 'https://github.com/sherlockmm/TYPageViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TYPageViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TYPageViewController' => ['TYPageViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'MJRefresh', '=3.1.15'
#s.dependency 'SwipeTableView'
end
