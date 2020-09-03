//
//  Checkbox.swift
//  Pushley
//
//  Created by Johnnie Cheng on 3/9/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

struct Checkbox: View {
    
    let label: String
    let size: CGFloat
    
    @Binding var isChecked: Bool
    
    init(label:String,
         isChecked: Binding<Bool>,
         size: CGFloat = 15)
    {
        self.label = label
        self._isChecked = isChecked
        self.size = size
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(nsImage: NSImage(named: self.isChecked ? "checkbox-checked" : "checkbox-unchecked") ?? NSImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.size, height: self.size)
            
            Text(label)
        }
        .onTapGesture { self.isChecked.toggle() }
    }
}
