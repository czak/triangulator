//
//  MainWindowController.swift
//  Trianglify
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    // MARK: - Properties
    
    var pattern: Pattern = Pattern(width: 640, height: 400, cellSize: 40, variance: 0.5, palette: "Reds")
    
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
