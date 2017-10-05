//
//  ContextMenuController.swift
//  kContext
//
//  Created by James Weber on 5/4/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ContextMenuController: NSObject, NSMenuDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBAction func quickClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let kubeConfigWindowController = KubeConfigWindow()
    
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: "contextIcon")
        icon?.isTemplate = true // true best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.menu?.delegate = self
        
        // read in the current kubectl config as json
        let clusterContexts = getConfig(outputType: "json")
        getMenuItems(systemItem: statusItem, contexts: clusterContexts)
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        // read in the current kubectl config as json
        let clusterContexts = getConfig(outputType: "json")
        getMenuItems(systemItem: statusItem, contexts: clusterContexts)
    }
    
    //populate menu items
    func getMenuItems(systemItem: NSStatusItem, contexts: ConfigParser.ConfigData){
        statusItem.menu?.removeAllItems()
        for context in contexts.contextNames {
            let newItem : NSMenuItem = NSMenuItem(title: context, action: #selector(sendContextChange(sender:)), keyEquivalent: "")
            newItem.target = self
            let nonCurrentIcon = NSImage(named: "nonCurrentContext")
            newItem.image = nonCurrentIcon
            if context == contexts.currentContext?.string {
                let currentIcon = NSImage(named: "currentContext")
                newItem.image = currentIcon
            }
            statusItem.menu!.addItem(newItem)
        }
        
        // add show config item
        let configItem : NSMenuItem = NSMenuItem(title: "Show Kubectl Config", action: #selector(showKubeConfig(sender:)), keyEquivalent: "")
        configItem.target = self
        statusItem.menu!.addItem(NSMenuItem.separator())
        statusItem.menu!.addItem(configItem)
        
        // add the quit menu item last
        let newItem : NSMenuItem = NSMenuItem(title: "Quit", action: #selector(quitClicked(sender:)), keyEquivalent: "")
        newItem.target = self
        statusItem.menu!.addItem(NSMenuItem.separator())
        statusItem.menu!.addItem(newItem)
        
        

    }

    // UI Actions
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    
    func getConfig(outputType: String) -> ConfigParser.ConfigData {
        let rc = shell(launchPath: "/usr/local/bin/kubectl", arguments: ["config", "view", "-o", outputType])
        let configParser = ConfigParser()
        let configContents = rc.0!
        let configData = configParser.parseConfig(config: configContents)
        return configData
    }
    
    @IBAction func sendContextChange(sender: NSMenuItem){
        changeContext(sender: sender)
    }
    
    func showKubeConfig(sender: AnyObject) {
        kubeConfigWindowController.window?.title = "Kubectl Config"
        kubeConfigWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        
    }
    
    
    // shell commands
    func changeContext(sender: NSMenuItem){
        let cluster = sender.title
        let rc = shell(launchPath: "/usr/local/bin/kubectl", arguments: ["config", "use-context", cluster])
        print(rc)
    }
    
    func shell(launchPath: String, arguments: [String] = []) -> (String? , Int32) {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        return (output, task.terminationStatus)
    }
}
