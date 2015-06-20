//
//  Pattern.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

struct Pattern {
    var width: CGFloat
    var height: CGFloat
    var cellSize: CGFloat
    
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
    
    var image: NSImage {
        return NSImage(size: size, flipped: false) { imageRect in
            self.draw()
            return true
        }
    }
    
    // TODO: Not sure if this should be the responsibility of Pattern.
    //       Perhaps some PNGRenderer would be prudent.
    var dataForPNG: NSData? {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
            pixelsWide: Int(width),
            pixelsHigh: Int(height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0)!
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: rep))
        
        draw()
        
        NSGraphicsContext.restoreGraphicsState()
        
        return rep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:])
    }
    
    func draw() {
        let rect = NSRect(origin: CGPointZero, size: size)
        
        // Red background
        NSColor.redColor().set()
        NSBezierPath(rect: rect).fill()
        
        // Blue circles
        NSColor.blueColor().set()
        
        for x in stride(from: 0, through: rect.width, by: self.cellSize) {
            for y in stride(from: 0, through: rect.height, by: self.cellSize) {
                let rect = NSRect(x: x, y: y, width: self.cellSize, height: self.cellSize)
                NSBezierPath(ovalInRect: rect).fill()
            }
        }
    }
}
