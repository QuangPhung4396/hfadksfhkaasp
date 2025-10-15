Pod::Spec.new do |spec|

  spec.name         = "hfadksfhkaasp"
  spec.version      = "0.0.3"
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

  spec.dependency 'SwiftSoup'
  spec.dependency 'CryptoSwift'
  spec.dependency 'Kingfisher'
  spec.dependency 'SnapKit'
  spec.dependency 'Google-Mobile-Ads-SDK'
  spec.vendored_frameworks = 'QRoot.xcframework'
end