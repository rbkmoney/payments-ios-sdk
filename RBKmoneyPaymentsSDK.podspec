Pod::Spec.new do |s|

  s.name = "RBKmoneyPaymentsSDK"
  s.version = "1.0.0"
  s.homepage = "https://github.com/rbkmoney/payments-ios-sdk"
  s.license = {
      :type => 'Apache License, Version 2.0',
      :file => 'LICENSE'
  }
  s.authors = "RBKmoney"
  s.summary = "RBKmoney Payments iOS SDK"
  s.description = "A framework that simplifies your iOS app integration with RBKmoney Payments."

  s.source = {
    :git => "https://github.com/rbkmoney/payments-ios-sdk.git",
    :tag => s.version.to_s
  }

  s.platforms = {
    :ios => '11.0'
  }

  s.swift_version = '5.1'

  s.source_files = "RBKmoneyPaymentsSDK/{Autogenerated Files,Sources}/**/*.swift"
  s.resources = "RBKmoneyPaymentsSDK/{Resources,Sources}/**/*.{xcassets,xib,storyboard}", "RBKmoneyPaymentsSDK/Resources/Data/**/*.json", "RBKmoneyPaymentsSDK/Resources/Strings/*.lproj/*.strings"
  s.frameworks = 'UIKit', 'PassKit'

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
  s.dependency 'R.swift.Library', '~> 5.0'

end
