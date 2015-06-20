//
//  MainWindowController.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    // MARK: - Outlets
    
    @IBOutlet weak var patternView: PatternView!
    
    // MARK: - Properties
    
    var width: CGFloat = 640 {
        didSet { updatePattern() }
    }
    
    var height: CGFloat = 400 {
        didSet { updatePattern() }
    }
    
    var cellSize: CGFloat = 40 {
        didSet { updatePattern() }
    }
    
    override func setNilValueForKey(key: String) {
        switch key {
        case "width": width = 1
        case "height": width = 1
        default: super.setNilValueForKey(key)
        }
    }
    
    func updatePattern() {
        patternView.pattern = Pattern(width: width, height: height, cellSize: cellSize)
    }
        
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}
