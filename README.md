# Swift Bezier Curve View

Create and edit arrows to light up your interface, with visual preview in Xcode **Storyboard** and **Interface Builder**.

![beziercurveviewstoryboard](https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png)

# Properties
| Anchors | What it does |
|:-------|:-----------|
| An _anchor_ can be located in any of `.topLeft`, `.topRight`, `.bottomLeft`, `.bottomRight` or `.center`| |
| `startAnchor` | one end of the bezier curve  |
| `endAnchor` | other end of the bezier curve. If it has an arrow, this is where the arrow point to |

| Offests | What it does |
|:-------|:-----------|
| Relative _offset_ to the anchor, in pixels. An offset is a convenient tool to add marging and breating space | |
| `startOffset` | Relative to `startAnchor` |
| `endOffset` | Relative to `endAnchor` |

| Curvature | What it does |
|:-------|:-----------|
| Bezier curves and controlled by aptly named _control points_. These act as tension vectors and control the rendering of the curve. |
| `startControl` | starting point |
| `endControl` | ending point |
| `showHandles` | visualize control points and associated tension |

| Appearance | What it does |
|:-------|:-----------|
| `lineWidth` | control the thickness of the line |
| `tintColor` | curve color |
| `arrowSize` | arrow dimension |

## Installation

Use Cocoapods or include the source file directly. Cocoapods preferred.

## Demo

Run `pod install` in the `BezierCurveExample` directory, open `BezierCurveExample.xcworkspace` and run.
