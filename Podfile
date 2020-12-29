# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

use_frameworks!

def global_pods
    pod 'Google-Mobile-Ads-SDK', '>= 7.69.0'
    pod 'MaterialComponents/Buttons', '>= 119.3.0'
    pod 'MaterialComponents/Buttons+ButtonThemer'
    pod 'MaterialComponents/Buttons+ColorThemer'
    pod 'MaterialComponents/Buttons+Theming'
    pod 'MaterialComponents/TextFields'
    pod 'Firebase/AdMob'
    pod 'Firebase/Messaging'
    pod 'Firebase/Analytics', '>= 7.3.0'
    pod 'Firebase/Crashlytics', '>= 7.3.0'
end

target 'BeerMais' do
    global_pods
end

target 'BeerMais Clip' do
    global_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
