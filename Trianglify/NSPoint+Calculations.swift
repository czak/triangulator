//
//  NSPoint+Calculations.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

extension NSPoint {
    // Calculate center among the given points
    static func center(points: NSPoint...) -> NSPoint {
        let numPoints = CGFloat(points.count)
        let x = points.reduce(0) { $0 + $1.x } / numPoints
        let y = points.reduce(0) { $0 + $1.y } / numPoints
        return NSPoint(x: x, y: y)
    }
    
    // Normalize coordinates to 0..<1 range within rect
    func normalizedInRect(rect: NSRect) -> NSPoint {
        var x = self.x / rect.width
        var y = self.y / rect.height
        if x < 0 { x = 0 } else if x > 1 { x = 1 }
        if y < 0 { y = 0 } else if y > 1 { y = 1 }
        return NSPoint(x: x, y: y)
    }
}