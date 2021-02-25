//
//  MyThumbnailView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyThumbnailView:View {
    @EnvironmentObject var theme:MyTheme
    
    let dim:CGFloat = 100.0
    let imageURL : URL?
    
    @StateObject var dataProvider = MyThumbnailProvider()
    
    var body: some View{
        VStack{
            if let uiImage = dataProvider.image , let thumbnail = Image(uiImage: uiImage){
                thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(width: dim, height: dim, alignment: .center)
                    .clipped()
            }
        }
        .frame(width: dim, height: dim, alignment: .center)
        .background(theme.thumbnailBackground)
        .onAppear{
            if let imageURL = imageURL {
                dataProvider.load(from: imageURL)
            }
        }
    }
}
