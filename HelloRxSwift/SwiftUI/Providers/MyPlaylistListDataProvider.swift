//
//  MyPlaylistListDataProvider.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/26.
//

import SwiftUI

class MyPlaylistListDataProvider: ObservableObject {
    
    @Published
    var loading:Bool = false;
    
    @Published
    var error:MyError?
    
    @Published
    var playlists: [MyPlaylistModels]?
    
    func refresh() {
        loading = true;
        // playlist creator
        playlists = [
            MyPlaylistModels(
                id: UUID().uuidString, name: "⭐ Favourites", description: "I could watch these whenever!", image: nil, movies: []
            )
            ,
            MyPlaylistModels(
                            id: UUID().uuidString,
                            name: "🧸 Chill Films",
                            description: "Films I like to relax to",
                            image: nil,
                            movies: []
                        )
        ]
        
        loading = false
    }
    
    @discardableResult
    func add(movies:[MyMovie],to index:Int) ->Int {
        guard let existingPlaylist = playlists,(0..<existingPlaylist.count).contains(index) else {
            return 0
        }
        let target = existingPlaylist[index]
        var update = existingPlaylist
        let combinedMovies = MergeMoviesLists(target.movies, movies)
        update[index] = MyPlaylistModels(id: target.id, name: target.name, description: target.description, image: target.image, movies: target.movies)
        
        self.playlists = update;
        
        return combinedMovies.count - target.movies.count;
    }
}
