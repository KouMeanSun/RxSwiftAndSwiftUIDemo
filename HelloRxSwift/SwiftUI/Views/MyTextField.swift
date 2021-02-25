//
//  MyTextField.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyTextField:View {
    
    @EnvironmentObject var theme : MyTheme

    var placeholder:String
    @Binding var text:String
    var disabled:Bool = false
    var onEditingChanged:(Bool) -> () = {_ in}
    var onCommit:() -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if(text.isEmpty){
                Text(placeholder).foregroundColor(theme.placeholderForeground)
            }
            TextField("", text: $text ,onEditingChanged:onEditingChanged,onCommit:onCommit)
                .autocapitalization(.none)
                .disabled(disabled)
        }
    }
}
