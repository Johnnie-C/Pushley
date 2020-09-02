//
//  NSTextViewWrapper.swift
//  Pushley
//
//  Created by Johnnie Cheng on 3/5/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

struct NSScrollableTextViewWrapper: NSViewRepresentable {
    
    typealias NSViewType = NSScrollView
    
    @Binding var text: String
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as? NSTextView
        textView?.isEditable = false
        textView?.isSelectable = true
        textView?.backgroundColor = .clear
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as? NSTextView
        textView?.string = text
        textView?.attributedString()
    }
    
}
