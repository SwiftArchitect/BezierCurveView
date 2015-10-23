Pod::Spec.new do |s|
  s.name         = "BezierCurveView"
  s.version      = "0.0.1"
  s.summary      = "iOS Bezier Curve View"
  s.description  = <<-DESC
                   Draw Bezier Arrows in a UIView, using familiar control handles.
                   These arrows will adjust neatly as the view gets resized, making
                   the best of interface orientation and device sizes.
                   DESC
  s.homepage     = "https://github.com/SwiftArchitect/BezierCurveView"
  s.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Xavier Schott" => "xschott@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/SwiftArchitect/BezierCurveView.git", :tag => "0.0.1" }
  s.source_files = "BezierCurveView/*.{h,m,swift}"
  s.requires_arc = true
end
