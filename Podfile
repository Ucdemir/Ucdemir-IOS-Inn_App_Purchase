# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IOS Inn App Purchase Example' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'RKDropdownAlert'
  # Pods for IOS Inn App Purchase Example

end

target 'YHY IOS In App Billing' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SQLite.swift', '0.14.1'

  # Pods for YHY IOS In App Billing

end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
