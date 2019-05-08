
source 'https://github.com/cocoapods/specs.git'
source 'https://bitbucket.org/UItachi/specs.git'

platform :ios, '12.0'

inhibit_all_warnings!

# Disable sending stats
# Issue: https://github.com/CocoaPods/CocoaPods/issues/4032
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

target 'NetworkTrafficCommon' do
    pod 'CocoaLumberjack', '~> 3.4'
    pod 'libextobjc', '~> 0.6'
    pod 'Masonry', '~> 1.1.0'
    pod 'AppCenter/Analytics', '~> 1.14'
    pod 'AppCenter/Crashes', '~> 1.14'

    # maintained by myself
    pod 'DSBaseViewController', '~> 1.4.1'
    pod 'UserDefaultsHelper', '0.1.2'

    target 'NetworkTraffic' do
        pod 'FLEX', '~> 2.4', :configurations => ['Debug']
        pod 'HUDHelper', '0.3.9'
        pod 'DSUtility', '0.5.3'
    end

    target 'NetworkTrafficUsage' do
        # pass
    end

    post_install do |installer|
        # https://github.com/CocoaPods/CocoaPods/issues/7314
        installer.pods_project.targets.each do |t|
            t.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
