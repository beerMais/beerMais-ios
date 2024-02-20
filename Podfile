# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

def global_pods
    pod 'Google-Mobile-Ads-SDK', '~> 10.13.0'
    pod 'MaterialComponents/Buttons', '>= 124.2.0'
    pod 'MaterialComponents/Buttons+ButtonThemer'
    pod 'MaterialComponents/Buttons+ColorThemer'
    pod 'MaterialComponents/Buttons+Theming'
    pod 'FirebaseRemoteConfig', '>= 10.17.0'
end

def main_app_pods
    pod 'Firebase/Messaging', '~> 10.17.0'
    pod 'Firebase/Crashlytics', '>= 10.17.0'
end

target 'BeerMais' do
    global_pods
    main_app_pods
end

target 'BeerMais Clip' do
    global_pods
end

target 'BeerMaisTests' do
    global_pods
    main_app_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
