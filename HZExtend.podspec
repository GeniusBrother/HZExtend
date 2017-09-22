Pod::Spec.new do |s|

  s.name         = "HZExtend" 
  s.version      = "0.6.2"    
  s.summary      = "MVVM, Powerful IOS Extension"
  s.description  = <<-DESC
                   MVVM, Powerful IOS Extension，available Network、Model、MMVM、URLManager、database
                   DESC
  s.homepage     = "https://github.com/GeniusBrother/HZExtend.git"
  s.license      = "MIT"
  s.author             = { "GeniusBrother" => "zuohong_xie@163.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/GeniusBrother/HZExtend.git", :tag => s.version }    
  s.frameworks = "CoreFoundation","Foundation","CoreGraphics","UIKit"

  s.public_header_files = 'HZExtend/Classes/**/*.h'
  s.source_files = 'HZExtend/Classes/**/*.{h,m}'

  s.dependency 'AFNetworking','~>3.1.0'
  s.dependency 'FMDB','~>2.7.0'
  # s.resource_bundles = {
  #   'HZNetwork' => ['HZExtend/Assets/*.png']
  # }

end
