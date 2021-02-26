//
//  MainContentView.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/23.
//

import SwiftUI

struct MainContentView:View{
    
    @EnvironmentObject var theme : MyTheme
    
    @StateObject var playlistProvider  = MyPlaylistListDataProvider()

    @StateObject var movieProvider = MyMovieListDataProvider()
    
    var dataSource = ["MainPageList"]
    
    @State var isEditing : Bool = false
    @State var searchText:String = ""
    @State var selectKeeper = Set<String>()
    
    var playListButton:some View{
        NavigationLink(
                    destination: MyPlaylistCatalogView(playlistProvider: playlistProvider)
                        .navigationTitle("Playlists")
        ){
            Image(systemName: "list.bullet")
        }
    }
    var editButton:some View{
        Button(isEditing ? "Cancel" : "Select"){
            if(isEditing){
                isEditing = false
            }else {
                isEditing = true
            }
        }
    }
    
    func renderMovie(_ movie :MyMovie) -> some View {
        MyMovieListItemView(movie: movie)
    }
    
    var body: some View{
        NavigationView{
            VStack {
                Divider()
                MyTextField(
                    placeholder: "Search for movie...",
                    text: $searchText,
                    disabled:isEditing || movieProvider.loading ,
                    onCommit: {
                        DismissKeyboard()
                        movieProvider.searchMovies(searchText)
                    }
                ).padding(.horizontal,theme.paddingUnit*2).padding(.vertical,theme.paddingUnit)
                
                Divider()
                VStack{
                    if movieProvider.loading {
                        MyLoadingView()
                    }else if let movies = movieProvider.movies{
                        if (!movies.isEmpty) {
                            List(movies,selection:$selectKeeper,rowContent:renderMovie)
                                .environment(\.editMode,.constant(isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                            if(isEditing && !selectKeeper.isEmpty){
                                NavigationLink(
                                    destination:
                                        MyAddToPlaylistView(
                                            playlistProvider: playlistProvider,
                                            movies: movies,
                                            selectKeeper: $selectKeeper,
                                            isEditing: $isEditing)
                                        .navigationTitle("Add to playlist"),
                                    label: {
                                        MyTextButton(label : "Add to Playlist")
                                    }
                                    ).padding(.top, theme.paddingUnit)
                            }
                        }else {
                            Text("No result found")
                        }
                    }
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                )
                
                if let error = movieProvider.error
                                {
                                    MyErrorView(error : error)
                                }
                
            } .navigationBarItems(leading: playListButton, trailing: editButton)
            .navigationBarTitle(Text("Movies"))
        }
//        .phoneOnlyStackNavigationView()
    }
}


func DismissKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
}
