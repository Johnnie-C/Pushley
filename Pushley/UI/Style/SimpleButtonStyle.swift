//
//  SimpleButtonStyle.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

enum ButtonStyleSheet {
    
    case `default`
    case blue
    
    var foregroundColor: Color {
        switch self {
        case .blue:
            return Color(.labelColor)
        default:
            return Color(.labelColor)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .blue:
            return Color(.controlAccentColor)
        default:
            return Color(.controlColor)
        }
    }
    
    var pressedColor: Color {
        switch self {
        case .blue:
            return Color(.selectedContentBackgroundColor)
        default:
            return Color(.controlAccentColor)
        }
    }
    
}

struct SimpleButtonStyle: ButtonStyle {
    
    var foregroundColor: Color
    var backgroundColor: Color
    var pressedColor: Color
    
    init(style: ButtonStyleSheet = .default) {
        foregroundColor = style.foregroundColor
        backgroundColor = style.backgroundColor
        pressedColor = style.pressedColor
    }
    
    init(foregroundColor: Color,
         backgroundColor: Color,
         pressedColor: Color)
    {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.pressedColor = pressedColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
       configuration.label
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.top, 1.5)
        .padding(.bottom, 2)
        .foregroundColor(foregroundColor)
        .background(configuration.isPressed ? pressedColor : backgroundColor)
        .cornerRadius(3)
    }
    
}
