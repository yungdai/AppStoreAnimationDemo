# Uncomment the next line to define a global platform for your project
 platform :ios, '12.2'

target 'AppStoreAnimationDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UXTestPrototypes
  # Use the following line to use App Center Analytics and Crashes.

  if File.exist?("/Users/yungdai/Yung's Respositories/UIExpandableCVCellKit/UIExpandableCVCellKit.podspec")
      pod 'UIExpandableCVCellKit', :path => "/Users/yungdai/Yung's Respositories/UIExpandableCVCellKit"
  else
      pod 'UIExpandableCVCellKit'
  end

  target 'AppStoreAnimationDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AppStoreAnimationDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
