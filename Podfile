source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

workspace 'RBKmoneyPaymentsSDK.xcworkspace'
project 'RBKmoneyPaymentsSDK.xcodeproj'

target 'Example' do
  # Target uses framework as dependency, install other dependencies explicitly
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'R.swift.Library', '~> 5.0'
end

target 'Example+Pods' do
  # Target uses framework as pod, other dependencies will be installed automatically by CocoaPods
  pod 'RBKmoneyPaymentsSDK', :path => './'
end

target 'RBKmoneyPaymentsSDK' do
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'R.swift', '~> 5.0'
  pod 'SwiftLint'
end

post_install do |installer|
  project = installer.pods_project
  targets = project.targets

  puts 'Post install: setting FATAL_SYNCHRONIZATION flag for RxSwift'

  rxswift_target = targets.find do |x|
    x.name == "RxSwift"
  end

  debug_configuration = rxswift_target.build_configuration_list["Debug"]
  flags = debug_configuration.build_settings.fetch("OTHER_SWIFT_FLAGS", ['$(inherited)'])
  flags.push("-D", "FATAL_SYNCHRONIZATION")
  debug_configuration.build_settings["OTHER_SWIFT_FLAGS"] = flags

  project.save
end
