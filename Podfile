# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pokedex' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pokedex

    pod 'Alamofire', '~> 4.0'

  target 'PokedexTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PokedexUITests' do
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
