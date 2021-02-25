//
//  MyErrorView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyErrorView:View {
    @EnvironmentObject var theme:MyTheme
     
    let error:MyError
    
    var body: some View{
        HStack{
            Spacer()
            Text(error.localizedDescription)
                .font(theme.errorFont)
                .fontWeight(theme.errorFontWeight)
                .foregroundColor(theme.errorForeground)
            Spacer()
        }
        .padding(.vertical,theme.paddingUnit)
        .padding(.horizontal,theme.paddingUnit * 2)
        .background(theme.errorBackground)
    }
    
}
