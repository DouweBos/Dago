#
# Be sure to run `pod lib lint DagoConstrained.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DagoConstrained'
  s.version          = '0.1.1'
  s.summary          = 'Swift implementation of the Dago Constrained API.'

  s.description      = <<-DESC
Dago Constrained is a wrapper around existing layout APIs for easy UI creation, and cross platform sharing of logic and code. 
The final goal is to be able to write UI code on either Android (Kotlin) or iOS (Swift), and to be able to run the code with the other platform with minimal changes required.
                       DESC

  s.homepage         = 'https://github.com/douwebos/Dago'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'douwebos' => 'douwe@douwebos.nl' }
  s.source           = { :git => 'https://github.com/douwebos/Dago.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/douwebos_nl'

  s.platform     = :ios, :tvos
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'DagoConstrained/Classes/**/*'
  
  # s.dependency 'RxSwift', '~> 5'
end
