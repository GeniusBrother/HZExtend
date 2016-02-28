Pod::Spec.new do |s|

  s.name         = "HZExtend"	
  s.version      = "0.5.3"		
  s.summary      = "a useful powrful IOS Extend"
  s.description  = <<-DESC
  					       a useful powrful IOS Extend，available Network、Model、MMVM
                   DESC
  s.homepage     = "https://github.com/GeniusBrother/HZExtend.git"
  s.license      = "MIT"
  s.author             = { "GeniusBrother" => "zuohong_xie@163.com" }
  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/GeniusBrother/HZExtend.git", :tag => s.version }    
  s.frameworks = "CoreFoundation","Foundation","CoreGraphics","UIKit"
  s.public_header_files = 'Classes/HZExtend.h'
  s.source_files = 'Classes/HZExtend.h'


   s.subspec 'Core' do |c|
    c.source_files = 'Classes/Core/**/*.{h,m}'
    c.public_header_files = 'Classes/Core/**/*.h'

    c.dependency 'AFNetworking','~>3.0.4'
    c.dependency 'MBProgressHUD'
    c.dependency 'FMDB'
    c.dependency 'FMDBMigrationManager'
    c.dependency 'MJExtension'
    c.dependency 'TMCache'
    c.dependency 'SDWebImage'
    c.dependency 'MJRefresh', '~> 3.0.7'
  end

  s.subspec 'Other' do |o|
    o.source_files = 'Classes/Other/**/*.{h,m}'
    o.public_header_files = 'Classes/Other/**/*.h'

  end
end
