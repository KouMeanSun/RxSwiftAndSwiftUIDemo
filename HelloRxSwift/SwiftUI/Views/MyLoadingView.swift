//
//  MyLoadingView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyLoadingView:View {
    @EnvironmentObject  var theme:MyTheme
    
    var body: some View{
        VStack(alignment: .center){
            Spacer()
            Text("Loading...")
                .font(theme.subheadingFont)
                .fontWeight(theme.subheadingFontWeight)
            Spacer()
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        
    }
}
