Pod::Spec.new do |spec|
  spec.name         = "BezierCurveView"
  spec.version      = "1.0.1"
  spec.summary      = "iOS Bezier Curve View"
  spec.description  = <<-DESC
                      Draw Bezier Arrows in a UIView, using familiar control handles.
                      These arrows will adjust neatly as the view gets resized, making
                      the best of interface orientation and device sizes.
                      DESC
  spec.homepage     = "https://github.com/SwiftArchitect/BezierCurveView"
  spec.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Xavier Schott" => "xschott@gmail.com" }
  spec.social_media_url = 'https://twitter.com/swiftarchitect'
  spec.platform     = :ios, "7.0"
  spec.source       = { :git => "https://github.com/SwiftArchitect/BezierCurveView.git", :tag => "v1.0.1" }
  spec.source_files = "BezierCurveView/*.{h,m,swift}"
  spec.requires_arc = true
end
