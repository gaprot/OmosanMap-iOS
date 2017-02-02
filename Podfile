use_frameworks!
platform :ios, '8.0'

target 'OmosanMaps' do
  pod 'SSZipArchive', '~> 1.1.0'
  pod 'Alamofire', '~> 3.5'
  pod 'AlamofireImage', '~> 2.5.0'
  pod 'Ji', '~> 1.2.0'
  pod 'SwiftyUserDefaults', '~> 2.2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '2.3'
      end
   end
end
