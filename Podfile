platform :ios, ‘15.0’
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Authenticator' do
  pod 'lottie-ios'
  
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'Alamofire'
  
  pod 'SwiftyStoreKit'

  pod 'OtterScaleiOS', :git => "https://github.com/AgentChe/OtterScaleiOS.git"
  
  pod 'FBSDKCoreKit'
  pod 'Amplitude-iOS'
  pod 'Branch'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'FirebaseFirestore'
  
  pod 'Toast-Swift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end
end
