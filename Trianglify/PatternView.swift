//
//  PatternView.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

private var myContext = 0

class PatternView: NSView {
    
    // MARK: - Properties
    
    var pattern: Pattern = Pattern(width: 640, height: 400, cellSize: 40) {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    // MARK: - Geometry

    // Store the aspect ratio constraint for easy removal
    // TODO: try without the stored property
    var aspectRatioConstraint: NSLayoutConstraint?
    
    override var intrinsicContentSize: NSSize {
        return pattern.size
    }
    
    override func updateConstraints() {
        if let constraint = aspectRatioConstraint {
            removeConstraint(constraint)
        }
        
        let aspectRatio = pattern.width / pattern.height
        let constraint = NSLayoutConstraint(item: self,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Height,
            multiplier: aspectRatio,
            constant: 0)
        addConstraint(constraint)
        
        // Store for removal later
        aspectRatioConstraint = constraint
        
        super.updateConstraints()
    }
    
    // MARK: - Drawing

    override func drawRect(dirtyRect: NSRect) {
        NSColor.blueColor().set()
        NSBezierPath(rect: bounds).fill()
    }
    
}
