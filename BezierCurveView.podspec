Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "BezierCurveView"
  spec.version      = "4.0.1"
  spec.summary      = "Swift Bezier Curve View"
  spec.description  = <<-DESC
                      Draw Bezier Arrows in a UIView, using familiar control handles.
                      These arrows will adjust neatly as the view gets resized, making
                      the best of interface orientation and device sizes.
                      DESC
  spec.homepage     = "https://github.com/SwiftArchitect/BezierCurveView"
  spec.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author       = { "Xavier Schott" => "http://swiftarchitect.com/swiftarchitect/" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.requires_arc = true
  spec.swift_version = '4.1.2'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/SwiftArchitect/BezierCurveView.git", :tag => "v4.0.1" }
  spec.exclude_files = "BezierCurveExample/*"
  spec.source_files = "BezierCurveView/*.{swift}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.framework = "UIKit"

end
