//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to Delaunay.playground.
//

import Cocoa

// Wylicza punkt środkowy między wskazanymi punktami
public func center(points: Point...) -> Point {
    let numPoints = Float(points.count)
    let x = points.reduce(0) { $0 + $1.x } / numPoints
    let y = points.reduce(0) { $0 + $1.y } / numPoints
    return (x, y)
}

public let gradients = [
    "Spectral": NSGradient(colors: ["#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b", "#ffffbf", "#e6f598", "#abdda4", "#66c2a5", "#3288bd", "#5e4fa2"].map { NSColor(hexString: $0) }),
    "RdYlBu": NSGradient(colors: ["#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf", "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695"].map { NSColor(hexString: $0) }),
    "Reds": NSGradient(colors: ["#fff5f0", "#fee0d2", "#fcbba1", "#fc9272", "#fb6a4a", "#ef3b2c", "#cb181d", "#a50f15", "#67000d"].map { NSColor(hexString: $0) })
]

// Współrzędne muszą być w zakresie 0.0...1.0
// czyli to nie jest prawdziwy "punkt"
//public func gradient(point: Point) -> NSColor {
//    let gradient = gradients["RdYlBu"]!
//    return gradient.interpolatedColorAtLocation(CGFloat(point.x + point.y) / 2)
//}

public func gradientFunc(palette: String) -> (Point -> NSColor) {
    let gradient = gradients[palette]!
    return { point in
        return gradient.interpolatedColorAtLocation(CGFloat(point.x + point.y) / 2)
    }
}

extension NSPoint {
    init(vertex: Point) {
        x = CGFloat(vertex.x)
        y = CGFloat(vertex.y)
    }
}

// Współrzędne punktu przeskalowane do zakresu 0.0...1.0
func scalePoint(point: Point, toRect rect: NSRect) -> Point {
    var x = point.x / Float(rect.width)
    var y = point.y / Float(rect.height)
    if x < 0 { x = 0 } else if x > 1 { x = 1 }
    if y < 0 { y = 0 } else if y > 1 { y = 1 }
    return (x, y)
}