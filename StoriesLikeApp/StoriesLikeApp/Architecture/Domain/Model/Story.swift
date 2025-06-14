//
//  Story.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

struct Story: Identifiable, Equatable {
    let id: String
    let imageURL: URL
    let timestamp: Date
    var isSeen: Bool
    var isLiked: Bool
}
