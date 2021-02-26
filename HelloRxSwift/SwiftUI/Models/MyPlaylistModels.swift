//
//  MyPlaylistModels.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/26.
//

import SwiftUI

struct MyPlaylistModels:Codable,Identifiable {
    let id          :String;
    let name        :String;
    let description :String;
    let image       :URL?;
    let movies      :[MyMovie]
}
