platform :ios, '15.0'
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

  # Fix for Xcode 16+/Clang 17 compile error in gRPC pods:
  # "A template argument list is expected after a name prefixed by the template keyword"
  # The `template` disambiguator before CallSeqFactory has no explicit argument list,
  # which newer Clang rejects. Strip it from the generated sources after each pod install.
  %w[gRPC-Core gRPC-C++].each do |grpc_pod|
    seq_file = File.join(installer.sandbox.root, grpc_pod,
                         'src/core/lib/promise/detail/basic_seq.h')
    next unless File.exist?(seq_file)
    contents = File.read(seq_file)
    patched = contents.gsub('Traits::template CallSeqFactory(', 'Traits::CallSeqFactory(')
    if patched != contents
      File.write(seq_file, patched)
      Pod::UI.puts "[grpc patch] removed stray `template` keyword in #{grpc_pod}/basic_seq.h"
    end
  end
end
