//
//  Palette.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 21.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

class Palette: NSObject {
    var name: String
    var colors: [NSColor]
    private var _gradient: NSGradient
    
    static var defaultPalettes = [
        Palette(name: "Spectral", colors: ["#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b", "#ffffbf", "#e6f598", "#abdda4", "#66c2a5", "#3288bd", "#5e4fa2"].map { NSColor(hexString: $0) }),
        Palette(name: "RdYlBu", colors: ["#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf", "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695"].map { NSColor(hexString: $0) }),
        Palette(name: "Reds", colors: ["#fff5f0", "#fee0d2", "#fcbba1", "#fc9272", "#fb6a4a", "#ef3b2c", "#cb181d", "#a50f15", "#67000d"].map { NSColor(hexString: $0) })
    ]
    
    init(name: String, colors: [NSColor]) {
        self.name = name
        self.colors = colors
        self._gradient = NSGradient(colors: colors)
    }
    
    func gradient(point: NSPoint) -> NSColor {
        return _gradient.interpolatedColorAtLocation((point.x + point.y) / 2)
    }
    
    func swatchImageForSize(size: NSSize) -> NSImage {
        return NSImage(size: size, flipped: false) { rect in
            let barWidth = rect.width / CGFloat(self.colors.count)
            for (i, color) in enumerate(self.colors) {
                let barRect = NSRect(x: CGFloat(i) * barWidth, y: 0, width: barWidth, height: rect.height)
                let path = NSBezierPath(rect: barRect)
                color.set()
                path.fill()
            }
            return true
        }
    }
}
