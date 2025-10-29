Pod::Spec.new do |spec|

  spec.name         = "hfadksfhkaasp"
  spec.version      = "0.0.9"
  spec.summary      = "First version"
  spec.description  = <<-DESC
                    A more detailed description of hfadksfhkaasp.
                    DESC
  spec.homepage     = 'https://github.com/QuangPhung4396/hfadksfhkaasp'
  spec.license   = { :type => 'MIT', :file => 'LICENSE' }
  spec.author    = { "QuangPhung4396" => "quang.phungvan1996@gmail.com" }
  spec.source    = { :git => "https://github.com/QuangPhung4396/hfadksfhkaasp.git", :tag => spec.version.to_s }
  spec.platform     = :ios, '15.0'
  spec.swift_version = '5.0'

  pod 'KRProgressHUD'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SDWebImage'
  pod 'SnapKit'

  spec.dependency 'KRProgressHUD'
  spec.dependency 'Toast-Swift'
  spec.dependency 'SDWebImage'
  spec.dependency 'SnapKit'
  spec.vendored_frameworks = 'QRoot.xcframework'
end