//
//  User.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: Int
    let name: String
    let profilePictureURL: URL
    let stories: [Story]
}
