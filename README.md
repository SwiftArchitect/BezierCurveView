# BezierCurveView
iOS Bezier Curve View

Create fancy arrows to light up your interface, all from the comfort of Storyboard and Interface Builder.

![beziercurveviewstoryboard](https://cloud.githubusercontent.com/assets/4073988/10705183/0ecbd50e-7991-11e5-8693-10b54587c837.png)

#Properties

 1. Control which corner the arrow starts from and points to using `startAnchor` and `endAnchor`. An anchor can be located in any of topLeft, topRight, bottomLeft, bottomRight or center.
 2. Control the relative offset to the anchor, in pixels, using `startOffset` and `endOffset`. An offset is a convenient tool to add marging and breating space
 3. Control the Bezier control points, albeit neither with mouse nor finger, using `startControl` and `endControl`. While those are adjusted with properties, you can visualize the familiar red handles during development by turning `showHandles` on.
 4. Control the thickness of the line using `lineWidth` and the size of the arrowhead using `arrowSize`.
 5. The curve is drawn with the `tintColor`.
