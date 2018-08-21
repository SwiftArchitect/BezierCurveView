# Swift Bezier Curve View

[![Build Status](https://travis-ci.org/SwiftArchitect/BezierCurveView.svg?branch=master)](https://travis-ci.org/SwiftArchitect/BezierCurveView)
[![CocoaPods](https://img.shields.io/cocoapods/v/BezierCurveView.svg)](https://cocoapods.org/pods/BezierCurveView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
![MIT License](https://img.shields.io/cocoapods/l/BezierCurveView.svg)

Bezier curves are very handy to point to objects in your interface, for onboarding and help screens:

![camerahint](https://cloud.githubusercontent.com/assets/4073988/23232001/a1028ede-f8fe-11e6-85c9-e48058e45e35.png)

Create and edit arrows to light up your interface, with visual preview in Xcode **Storyboard** and **Interface Builder**.

## Technical Discussion

In **Interface Builder**, position a `BezierCurveView` and drop two `BezierCurveHandle` inside it.
1. `BezierCurveView` represents the drawing space. It can be as large as the `UIWindow` to prevent curve clipping.
2. `BezierCurveHandle` represents the two handles required by a [Cubic Bezier Curve](http://learn.scannerlicker.net/2014/04/16/bezier-curves-and-type-design-a-tutorial/). It adopts the `BezierHandleProtocol`, which provides control point information.

The combination `BezierCurveView` + 2 `BezierCurveHandle` yields live preview in **Interface Builder**, with unprecedented flexibility:
![cameraib](https://cloud.githubusercontent.com/assets/4073988/23231917/58469bfe-f8fe-11e6-89f8-c5a4741a9534.png).
Because a `BezierCurveHandle` is itself a `UIView`, it can be controlled by **AutoLayout** constraints, and thus adapt automatically to changes in sizes and orientations, with exactly **0 lines of code**. And since these handles are themselves extensions to the `BezierHandleProtocol`, you can tailor any of your `UIView` subclasses to control handles as well.

#### Notes
1. _Make sure that a `BezierCurveView` contains exactly two subviews adopting `BezierHandleProtocol` for any drawing to take place_
2. _In most situations, `BezierCurveView` and `BezierCurveHandle` background color should be clear_
3. `BezierCurveView` will be refreshed any time its `frame` is updated, providing dynamic animations:
![bezierelasticity](https://cloud.githubusercontent.com/assets/4073988/23234535/3973f36c-f907-11e6-83b5-b02b9d5e13b4.gif)
([replay](https://cloud.githubusercontent.com/assets/4073988/23234535/3973f36c-f907-11e6-83b5-b02b9d5e13b4.gif))

# Bezier Curve View Properties
| IBInspectable | What it does |
|:-------|:-----------|
| `lineWidth` | bezier curve thickness ; default is 1.5  |
| `tintColor` | color of the curve ; defaults to black if absent |

# Bezier Handle View Properties
| IBInspectable | What it does |
|:-------|:-----------|
| `dx` | horizontal component of the control point ; default is 0 |
| `dy` | vertical component of the control point ; default is -10.0 (control point is 10.0 pixels below the anchor |
| `shape` | one of `none`, `arrowHead`, `circle` or `disc`, default is `none` |
| `size` | dimensions of the `shape`: a shaft **length** for the arrow, a **radius** for circles and discs (†) ; default is 15.0


(†) _The bezier curve end point is **adjusted** to start from the end of the shape_

## Installation

Use Cocoapods or include the source file directly. Cocoapods preferred.

**API Compatibility**: version 4.x introduces `BezierHandleProtocol`, `BezierHandleView` and `BezierCurveView`, deprecating 3.x `BezierCurveArrowView`.
## Demo

Run `pod install` in the `BezierCurveExample` directory, open `BezierCurveExample.xcworkspace` and run.
![beziercurveviewstoryboard](https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png)

## Getting Help

Search for **BezierCurveView** answers on [Stack Overflow](http://stackoverflow.com/), or ask questions to be adressed by the community. You can also [contact the author](http://swiftarchitect.com/contact/). 

