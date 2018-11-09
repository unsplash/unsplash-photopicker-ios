Pod::Spec.new do |spec|
  spec.name             = 'UnsplashPhotoPicker'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'MIT' }
  spec.homepage         = 'https://github.com/unsplash/unsplash-photopicker-ios'
  spec.authors          = { 'Unsplash' => 'friends@unsplash.com' }
  spec.summary          = 'An iOS photo picker to search for photos on Unsplash.'
  spec.source           = { :git => 'https://github.com/unsplash/unsplash-photopicker-ios.git', :tag => 'v1.0.0' }
  spec.source_files     = 'UnsplashPhotoPicker/UnsplashPhotoPicker/**/*.{h,m,swift,xib,strings,stringsdict}'
  spec.framework        = 'Foundation', 'UIKit'
  spec.platform         = :ios, '11.0'
  spec.requires_arc     = true
  spec.swift_version    = '4.2'
end
