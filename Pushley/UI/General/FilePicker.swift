//
//  FilePicker.swift
//  Pushley
//
//  Created by Johnnie Cheng on 27/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

class FilePickerBuilder {
    
    var title: String
    var showsResizeIndicator = true
    var allowsMultipleSelection = false
    var canChooseDirectories = false
    var showsHiddenFiles = false
    var allowedFileTypes: [String]?
    
    init(title: String = "") {
        self.title = title
    }
    
    static func defaultSingleFilePicker() -> FilePickerBuilder {
        let builder = FilePickerBuilder()
        
        builder.showsResizeIndicator = true
        builder.allowsMultipleSelection = false
        builder.canChooseDirectories = false
        builder.showsHiddenFiles = false
        
        return builder
    }
    
}

class FilePicker: NSObject {
    
    static func pick(builder: FilePickerBuilder) -> [URL]? {
        let dialog = NSOpenPanel()

        dialog.title = builder.title
        dialog.showsResizeIndicator = builder.showsResizeIndicator
        dialog.showsHiddenFiles = builder.showsHiddenFiles
        dialog.allowsMultipleSelection = builder.allowsMultipleSelection
        dialog.canChooseDirectories = builder.canChooseDirectories
        dialog.allowedFileTypes = builder.allowedFileTypes
        dialog.runModal()
        
        return dialog.urls
    }
    
}
