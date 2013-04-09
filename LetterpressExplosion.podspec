Pod::Spec.new do |s|
  s.name         = "LetterpressExplosion"
  s.version      = "0.0.1"
  s.summary      = "Category on `UIView` called Explode that will take the uiview and explode it into pieces."
  s.homepage     = "https://github.com/vibrazy/letterpressexplosion"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = 'Daniel Tavares'
  s.source       = { :git => "https://github.com/vibrazy/letterpressexplosion.git", :commit => '24a5ffa043adf26254170c9e5cdbd62e95aa9f43' }
  s.platform     = :ios, '6.0'
  s.source_files = 'LetterPressExplosion/LetterPressExplosion/Categories/**/*.{h,m}'
  s.public_header_files = 'LetterPressExplosion/LetterPressExplosion/Categories/**/*.{h,m}'
  # s.frameworks = 'UIKit', 'QuartzCore'
  s.requires_arc = true
end
