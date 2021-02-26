//
//  MyPlaylistView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/26.
//

import SwiftUI

struct MyPlaylistCatalogView:View {
    @EnvironmentObject var theme:MyTheme
    @ObservedObject var playlistProvider:MyPlaylistListDataProvider
    
    func onAppear(){
        if(playlistProvider.playlists == nil  ){
            playlistProvider.refresh()
        }
    }
    
    func renderPlaylist(_ playlist:MyPlaylistModels) -> some View{
        NavigationLink(destination:MyPlaylistDetailView(playlist: playlist)){
            MyPlaylistListItemView(playlist: playlist)
        }
    }
    var body: some View{
        VStack{
            VStack{
                if(playlistProvider.loading){
                    MyLoadingView()
                }else{
                    List(playlistProvider.playlists ?? [] ,rowContent:renderPlaylist)
                }
            }.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .topLeading)
            
            if let error = playlistProvider.error {
                MyErrorView(error: error)
            }
        }
        .onAppear(perform: onAppear)
    }
}

struct MyPlaylistDetailView:View {
    @EnvironmentObject var theme:MyTheme
    
    let playlist:MyPlaylistModels
    
    func renderMovie(_ movie :MyMovie) -> some View{
       return MyMovieListItemView(movie: movie)
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: theme.paddingUnit){
            HStack(alignment:.center, spacing: 0){
                Spacer()
                VStack(alignment: .center, spacing: theme.paddingUnit){
                    MyThumbnailView(imageURL: playlist.image)
                        .cornerRadius(theme.paddingUnit)
                        .padding(.top,theme.paddingUnit)
                    
                    Text(playlist.name)
                        .font(theme.subheadingFont)
                        .fontWeight(theme.superheadingFontWeight)
                        .padding(.top,theme.paddingUnit)
                    
                    Text(playlist.description)
                        .font(theme.subheadingFont)
                        .fontWeight(theme.subheadingFontWeight)
                        .padding(.bottom,theme.paddingUnit)
                }
                Spacer()
            }
            Divider()
            
            List(playlist.movies,rowContent:renderMovie)
        }
    }
}

struct MyAddToPlaylistView:View {
    @EnvironmentObject var theme:MyTheme
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var playlistProvider:MyPlaylistListDataProvider
    let movies:[MyMovie]
    @Binding var selectKeeper :Set<String>
    @Binding var isEditing:Bool
    
    @State var showAlert :Bool = false
    @State var alertMessage:String = ""
    @State var didSucceed:Bool = false
    
    func onAppear(){
        if(playlistProvider.playlists == nil){
            playlistProvider.refresh()
        }
    }
    
    func addMoviesTo(playlist:MyPlaylistModels){
        let index = playlistProvider.playlists?.firstIndex{ $0.id == playlist.id } ?? -1
    
        if(index > -1){
            let selectedMovies = movies.filter { selectKeeper.contains($0.id) }
            
            if(!selectedMovies.isEmpty){
                let added  = playlistProvider.add(movies: selectedMovies, to: index)
                
                if(added == selectedMovies.count){
                    alertMessage = "Added!"
                }else {
                    alertMessage = "Added (some duplicates were skipped)!"
                }
                
                selectKeeper.removeAll()
                isEditing = false;
                didSucceed = true;
            }else {
                alertMessage = "Could not find movies to add"
                didSucceed = false
            }
        }else {
            alertMessage = "Could not find playlist"
            didSucceed = false;
        }
        
        showAlert = true;
    
    }
    
    func renderPlaylist(_ playlist:MyPlaylistModels) -> some View{
        MyPlaylistListItemView(playlist: playlist).onTapGesture {
            addMoviesTo(playlist: playlist)
        }
    }
    
    var body: some View{
        VStack{
            VStack{
                if(playlistProvider.loading){
                    MyLoadingView()
                }else{
                    List(playlistProvider.playlists ?? [] ,rowContent:renderPlaylist)
                }
            }.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .topLeading)
            
            if let error = playlistProvider.error {
                Text("Error:\(error.localizedDescription)")
            }
            Text("My Favorite color is black")
                .font(theme.headingFont)
                .fontWeight(theme.headingFontWeight)
        }.alert(isPresented: $showAlert)
            {
            Alert(
                title: Text(didSucceed ? "Success" : "failed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
                    {
                        if(didSucceed){
                            presentationMode.wrappedValue.dismiss();
                        }
                    }
            )
        }
        .onAppear(perform: onAppear)
    }
}
struct MyPlaylistListItemView :View{
    @EnvironmentObject var theme:MyTheme
    let playlist:MyPlaylistModels
    
    var body: some View{
        HStack(alignment: .center, spacing: theme.paddingUnit){
            MyThumbnailView(imageURL: playlist.image).cornerRadius(theme.paddingUnit)
            
            VStack(alignment: .leading, spacing: theme.paddingUnit){
                Text(playlist.name)
                    .font(theme.headingFont)
                    .fontWeight(theme.headingFontWeight)
                
                Text(playlist.description)
                    .font(theme.subheadingFont)
                    .fontWeight(theme.subheadingFontWeight)
                
                Spacer()
            }
            .padding(.all,theme.paddingUnit)
        }
    }
}
