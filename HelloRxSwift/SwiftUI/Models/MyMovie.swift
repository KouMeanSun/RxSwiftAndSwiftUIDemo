//
//  MyMovie.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

struct MyMovie:Encodable,Identifiable {
    let id : String;
    let title :String;
    let year :String;
    let poster :URL?;
}

extension MyMovie :Decodable{
    private enum Codingkeys:String ,CodingKey{
        case id = "imdbID" ,title = "Title",year = "Year" ,poster = "Poster"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        title = (try values.decode(String.self, forKey: .title)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        year = (try values.decode(String.self, forKey: .year)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        poster = URL(string: try values.decode(String.self
                                               , forKey: .poster))
    }
}

func MergeMoviesLists(_ movies1 :[MyMovie],_ movies2 :[MyMovie] ) -> [MyMovie]{
    return movies1+movies2.filter{
        movie in !movies1.contains(where :{ $0.id == movie.id})
    }
}
