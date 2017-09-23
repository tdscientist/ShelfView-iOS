#
# Be sure to run `pod lib lint ShelfView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShelfView'
  s.version          = '1.0'
  s.summary          = 'iOS custom view to display books on shelf.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS custom view to display books on shelf, mimicking a real library.
                       DESC

  s.homepage         = 'https://github.com/tdscientist/ShelfView-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adeyinka Adediji' => 'tdscientist@gmail.com' }
  s.source           = { :git => 'https://github.com/tdscientist/ShelfView-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tdscientist'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ShelfView/Classes/**/*'
  
  s.resource_bundles = {
     'ShelfView' => ['ShelfView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Kingfisher', '~> 3.0'
end
