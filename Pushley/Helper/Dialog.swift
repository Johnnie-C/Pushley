//
//  Dialog.swift
//  Pushley
//
//  Created by Johnnie Cheng on 27/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

class Dialog: NSObject {
    
    static func getInputText(title: String,
                             informativeText: String = "",
                             defaultValue: String = "",
                             needSecure: Bool = false,
                             frame: NSRect = NSRect(x: 0, y: 0, width: 200, height: 24))
        -> String?
    {
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.messageText = title
        alert.informativeText = informativeText
        
        var textField: NSTextField

        if needSecure {
            textField = NSSecureTextField(frame: frame)
        }
        else {
            textField = NSTextField(frame: frame)
        }
        textField.stringValue = defaultValue
        alert.accessoryView = textField
        
        let response: NSApplication.ModalResponse = alert.runModal()

        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            return textField.stringValue
        }
        
        return nil
    }
    
    static func showSimpleAlert(title: String,
                                informativeText: String = "",
                                frame: NSRect = NSRect(x: 0, y: 0, width: 200, height: 24))
    {
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = title
        alert.informativeText = informativeText
        alert.runModal()
    }
    
}
