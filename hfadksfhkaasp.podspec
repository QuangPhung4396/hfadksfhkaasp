Pod::Spec.new do |spec|

  spec.name         = "hfadksfhkaasp"
  spec.version      = "0.0.2"
  spec.summary      = "First version"
  spec.description  = <<-DESC
                    A more detailed description of hfadksfhkaasp.
                    DESC
  spec.homepage     = 'https://github.com/QuangPhung4396/hfadksfhkaasp'
  spec.license   = { :type => 'MIT', :file => 'LICENSE' }
  spec.author    = { "QuangPhung4396" => "quang.phungvan1996@gmail.com" }
  spec.source    = { :git => "https://github.com/QuangPhung4396/hfadksfhkaasp.git", :tag => "0.0.2" }
  spec.platform     = :ios, '15.0'
  spec.source_files = 'hfadksfhkaasp/**/*.swift'
  spec.swift_version = '5.0'
  spec.static_framework   = true
  spec.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }

  spec.dependency 'SwiftSoup', '~> 2.7.3'
  spec.dependency 'CryptoSwift', '~> 1.8.4'
  spec.dependency 'Kingfisher', '~> 7.12.0'
  spec.dependency 'SnapKit', '~> 5.7.1'

end