platform :ios, '13.0'

target 'GitHub Search' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitHub Search
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SDWebImage', '~> 5.0'
  pod 'PromiseKit', '~> 6.8'
  pod 'Resolver'

  target 'GitHub SearchTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'OHHTTPStubs/Swift'
    pod 'Quick'
    pod 'Nimble'
  end

  target 'GitHub SearchUITests' do
    pod 'Quick'
    pod 'Nimble'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end