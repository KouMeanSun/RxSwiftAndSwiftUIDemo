//
//  OMDBModel.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

enum OMDBAPIResponse : String, Codable
{
    case success = "True"
    case failed  = "False"
}

struct OMDBAPIMovieSearchResult : Decodable
{
    let Search      : [MyMovie]?
    let Error       : String?
    let Response    : OMDBAPIResponse
}
