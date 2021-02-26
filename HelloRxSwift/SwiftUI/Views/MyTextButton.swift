//
//  MyTextButton.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/26.
//

import SwiftUI

struct MyTextButton : View
{
    @EnvironmentObject var theme : MyTheme
    
    var label: String
    var disabled : Bool = false
    
    public var body: some View{
        Text(label)
            .font(theme.buttonFont)
            .fontWeight(theme.buttonFontWeight)
            .fixedSize(horizontal: true, vertical: true)
            .lineLimit(1)
            .foregroundColor(theme.buttonForeground)
            .padding(.vertical, theme.paddingUnit)
            .padding(.horizontal, theme.paddingUnit * 2)
            .background(theme.buttonBackground)
            .cornerRadius(theme.paddingUnit)
            .grayscale(disabled ? 1.0 : 0.0)
    }
}
