//
//  SwiftDataManager.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {
    
    static let shared = SwiftDataManager()
    private let modelContainer: ModelContainer
    
    var modelContext: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        let schema = Schema([StoryEntity.self])
        let configuration = ModelConfiguration(
            "StoriesLikeAppModel",
            schema: schema
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
