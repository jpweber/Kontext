//
//  KubeConfigWindow.swift
//  kContext
//
//  Created by James Weber on 5/6/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import Cocoa

class KubeConfigWindow: NSWindowController {

    
    @IBOutlet weak var configLabel: NSTextFieldCell!
    
    convenience init() {
        self.init(windowNibName: "KubeConfigWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        let menuController = ContextMenuController()
        let rc = menuController.shell(launchPath: "/usr/local/bin/kubectl", arguments: ["config", "view"])
        configLabel.title = rc.0!
    }
    
}
