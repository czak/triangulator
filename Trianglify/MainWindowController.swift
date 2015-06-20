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
    
    var pattern: Pattern {
        return Pattern(width: width, height: height, cellSize: cellSize, variance: 0.5, palette: "RdYlBu")
    }
    
    override func setNilValueForKey(key: String) {
        switch key {
        case "width": width = 1
        case "height": width = 1
        default: super.setNilValueForKey(key)
        }
    }
    
    func updatePattern() {
        patternView.pattern = pattern
    }
    
    override var windowNibName: String {
        return "MainWindowController"
    }

    // MARK: - Saving
    
    func saveDocument(sender: AnyObject) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png"]
        panel.beginSheetModalForWindow(window!, completionHandler: { button in
            if button == NSFileHandlingPanelCancelButton { return }
            
            if let url = panel.URL, data = self.pattern.dataForPNG {
                data.writeToURL(url, atomically: true)
            }
            else {
                let alert = NSAlert()
                alert.messageText = "Unable to save image"
                alert.beginSheetModalForWindow(self.window!, completionHandler: nil)
            }
        })
    }
    
}
