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
    var isEditable = true
    var textSize: CGFloat = 17
    
    @Binding var text: String
    
    var didEndEditing: (() -> Void)?

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as? NSTextView
        textView?.font = NSFont.systemFont(ofSize: textSize)
        textView?.isEditable = isEditable
        textView?.isSelectable = true
        textView?.isAutomaticQuoteSubstitutionEnabled = false;
        textView?.backgroundColor = .clear
        textView?.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as? NSTextView
        guard textView?.string != text else { return }
        
        textView?.string = text
        textView?.display() // force update UI to re-draw the string
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        
        var view: NSScrollableTextViewWrapper
        
        init(_ view: NSScrollableTextViewWrapper) {
            self.view = view
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            view.text = textView.string
        }
        
        func textDidEndEditing(_ notification: Notification) {
            view.didEndEditing?()
        }
        
    }
    
}
