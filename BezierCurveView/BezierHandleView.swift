//    @file:    BezierHandleView.swift
//    @project: BezierCurveView
//
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2017, Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import UIKit

@IBDesignable
class BezierHandleView: UIView {

    @IBInspectable public var dx:CGFloat = 0
    @IBInspectable public var dy:CGFloat = -10
    @IBInspectable public var shape:NSInteger = BezierCurveView.Shape.none.rawValue
    @IBInspectable public var size:CGFloat = 15

    override func draw(_ rect: CGRect) {
        // Invisible
    }
}

extension BezierHandleView: BezierHandleProtocol {

    public var controlPoint: CGPoint {
        get {
            return CGPoint(x: dx, y: dy)
        }
        set {
            dx = newValue.x
            dy = newValue.y
        }
    }

    public var anchor:CGPoint {
        get {
            return center
        }
        set {
            center = newValue
        }
    }

    public var terminalShape: BezierCurveView.Shape {
        get {
            return BezierCurveView.Shape(rawValue: shape) ?? BezierCurveView.Shape.none
        }
        set {
            self.shape = newValue.rawValue
        }
    }

    public var terminalSize: CGFloat {
        get {
            return size
        }
        set {
            size = newValue
        }
    }
}
