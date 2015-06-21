//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to Delaunay.playground.
//

import Cocoa

// Wylicza punkt środkowy między wskazanymi punktami
public func center(points: NSPoint...) -> NSPoint {
    let numPoints = CGFloat(points.count)
    let x = points.reduce(0) { $0 + $1.x } / numPoints
    let y = points.reduce(0) { $0 + $1.y } / numPoints
    return NSPoint(x: x, y: y)
}

//extension NSPoint {
//    init(vertex: Point) {
//        x = CGFloat(vertex.x)
//        y = CGFloat(vertex.y)
//    }
//}

// Współrzędne punktu przeskalowane do zakresu 0.0...1.0
func scalePoint(point: NSPoint, toRect rect: NSRect) -> NSPoint {
    var x = point.x / rect.width
    var y = point.y / rect.height
    if x < 0 { x = 0 } else if x > 1 { x = 1 }
    if y < 0 { y = 0 } else if y > 1 { y = 1 }
    return NSPoint(x: x, y: y)
}