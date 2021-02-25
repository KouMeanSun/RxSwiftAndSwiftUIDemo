//
//  MyMovieListItemView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyMovieListItemView:View {
    @EnvironmentObject var theme:MyTheme
    let movie :MyMovie
    
    var body: some View{
        HStack(alignment: .center, spacing: theme.paddingUnit){
            // TODO 图片view
            MyThumbnailView(imageURL: movie.poster)
            VStack(alignment: .leading, spacing: theme.paddingUnit){
                Text(movie.title)
                    .font(theme.headingFont)
                    .fontWeight(theme.headingFontWeight)
                
                Text(movie.year)
                    .font(theme.subheadingFont)
                    .fontWeight(theme.subheadingFontWeight)
                
                Spacer()
            }.padding(.all,theme.paddingUnit)
        }
    }
}
