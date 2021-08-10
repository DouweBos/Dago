#
# Be sure to run `pod lib lint Dago.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Dago'
  s.version          = '0.1.8'
  s.summary          = 'Swift implementation of the Dago API.'

  s.description      = <<-DESC
Dago is a wrapper around many common components of a mobile SDK, to standardize the function calls for element creation, and user interaction.
The final goal is to be able to write UI code on either Android (Kotlin) or iOS (Swift), easily track button taps etc in Mixpanel or other user analytics packages, and to be able to run the code on the other platform with minimal changes required.
                       DESC

  s.homepage         = 'https://github.com/douwebos/Dago-Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'douwebos' => 'douwe@douwebos.nl' }
  s.source           = { :git => 'https://github.com/douwebos/Dago-Swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/douwebos_nl'

  s.platform     = :ios, :tvos
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'DagoCore/DagoCore/Classes/**/*'
  end

  s.subspec 'Constrained' do |ss|
    ss.source_files = 'DagoConstrained/DagoConstrained/Classes/**/*'

    ss.dependency 'Dago/Core', "~> #{s.version}"
  end
  
  s.subspec 'Tracked' do |ss|
    ss.source_files = 'DagoTracked/DagoTracked/Classes/**/*'

    ss.dependency 'Dago/Core', "~> #{s.version}"
  
    ss.dependency 'RxSwift', '~> 6'
    ss.dependency 'RxCocoa', '~> 6'
  end
end
