platform :ios, '7.0'

link_with 'PASchedules'

pod 'AFNetworking', '2.5.0'
pod 'DZNEmptyDataSet', '1.4.1'
pod 'SVProgressHUD', '1.0'
pod 'CRNavigationController', '1.1'
pod 'CTFeedback', :git => 'https://github.com/ruddfawcett/CTFeedback.git'
pod 'VTAcknowledgementsViewController'

post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'Pods-Acknowledgements.plist', :remove_destination => true)
end
