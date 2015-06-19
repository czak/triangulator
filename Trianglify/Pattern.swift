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
}
