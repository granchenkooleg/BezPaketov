# Pods for Bezpaketov# Uncomment the next line to define a global platform for your project
# platform :ios, '10.2'

target 'BezPaketov' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '10.2'
    use_frameworks!
    
    pod 'RealmSwift'
    pod 'Alamofire'
    pod 'SnapKit', '~> 3.0.0'
    pod 'SwiftyJSON'
    pod 'FacebookCore', '~> 0.2.0'
    pod 'FacebookLogin', '~> 0.2.0'
    pod 'Google/SignIn'
    pod 'VK-ios-sdk'
    pod 'SDWebImage'
    pod 'AlamofireNetworkActivityIndicator'
    
    target 'BezPaketovTests' do
        use_frameworks!
        
        pod 'Quick'
        pod 'Nimble'
    end
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
    
end
