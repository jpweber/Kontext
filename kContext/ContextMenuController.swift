//
//  ContextMenuController.swift
//  kContext
//
//  Created by James Weber on 5/4/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import Cocoa

class ContextMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBAction func quickClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: "contextIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}
