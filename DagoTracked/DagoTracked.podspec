#
# Be sure to run `pod lib lint DagoTracked.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DagoTracked'
  s.version          = '0.1.2'
  s.summary          = 'Swift implementation of the Dago Tracked API.'

  s.description      = <<-DESC
Dago Tracked is a wrapper around existing RxCocoa APIs for easy tracking of user interaction, and cross platform sharing of logic and code.
The final goal is to be able to write UI code on either Android (Kotlin) or iOS (Swift), have easy button tap etc tracked in Mixpanel or other user analytics packages, and to be able to run the code on the other platform with minimal changes required.
                       DESC

  s.homepage         = 'https://github.com/douwebos/Dago-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'douwebos' => 'douwe@douwebos.nl' }
  s.source           = { :git => 'https://github.com/douwebos/Dago.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/douwebos_nl'

  s.platform     = :ios, :tvos
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'DagoTracked/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'
end
