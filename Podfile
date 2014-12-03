platform :ios, '7.0'

link_with 'PASchedules'

pod 'AFNetworking', '2.5.0'
pod 'SVProgressHUD', '1.0'
pod 'CTFeedback', :git => 'https://github.com/ruddfawcett/CTFeedback.git'
pod 'VTAcknowledgementsViewController'
pod 'Mixpanel'
pod 'CrashlyticsFramework', '~> 2.2'

post_install do |installer|
    require 'fileutils'

    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'Pods-Acknowledgements.plist', :remove_destination => true)
end
