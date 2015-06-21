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
    
    @IBOutlet weak var palettePopUpButton: NSPopUpButton!
    @IBOutlet weak var backgroundView: NSView!
    
    // MARK: - Properties
    
    var pattern: Pattern = Pattern(width: 640, height: 400, cellSize: 40, variance: 0.5, palette: Palette.defaultPalettes[0])
    
    // MARK: - Window setup
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // White background under the image
        backgroundView.layer!.backgroundColor = CGColorCreateGenericGray(1, 1)
        
        populatePalettesPopup()
    }
    
    func populatePalettesPopup() {
        let menu = palettePopUpButton.menu!
        
        for palette in Palette.defaultPalettes {
            let item = NSMenuItem()
            item.title = ""
            item.representedObject = palette
            item.image = palette.swatchImageForSize(NSSize(width: 110, height: 13))
            menu.addItem(item)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changePalette(sender: NSPopUpButton) {
        pattern.palette = sender.selectedItem!.representedObject as! Palette
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
