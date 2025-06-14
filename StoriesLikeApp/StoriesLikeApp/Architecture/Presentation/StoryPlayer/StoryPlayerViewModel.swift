//
//  StoryPlayerViewModel.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftUI

protocol StoryPlayerViewModel: ObservableObject {
    var storyGroups: [[Story]] { get set }
    var currentGroupIndex: Int { get set }
    var currentStoryIndex: Int { get set }
    var progress: [CGFloat] { get set }
    var currentStories: [Story] { get }
    var currentStory: Story { get }
    
    func advance()
    func goBack()
    func toggleLike()
    func close()
}

final class StoryPlayerViewModelImpl: StoryPlayerViewModel {
    
    @Published var storyGroups: [[Story]]
    @Published var currentGroupIndex: Int
    @Published var currentStoryIndex: Int
    @Published var progress: [CGFloat]
    
    private let storyDuration: TimeInterval = 10
    private var timer: Timer?

    init(storyGroups: [[Story]], startGroup: Int = 0) {
        self.storyGroups = storyGroups
        self.currentGroupIndex = startGroup
        self.currentStoryIndex = 0
        self.progress = Array(repeating: 0, count: storyGroups[startGroup].count)
        markCurrentAsSeen()
        startTimer()
    }

    var currentStories: [Story] { storyGroups[currentGroupIndex] }
    var currentStory: Story { currentStories[currentStoryIndex] }

    func advance() {
        stopTimer()
        progress[currentStoryIndex] = 1.0

        if currentStoryIndex < currentStories.count - 1 {
            currentStoryIndex += 1
        } else {
            advanceToNextGroup()
            return
        }

        markCurrentAsSeen()
        updateProgressBars()
        resetFutureProgress()
        startTimer()
    }

    func goBack() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            restartTimer()
        } else if currentGroupIndex > 0 {
            currentGroupIndex -= 1
            currentStoryIndex = storyGroups[currentGroupIndex].count - 1
            resetProgress(for: currentGroupIndex)
            markCurrentAsSeen()
            restartTimer()
        }
    }

    func toggleLike() {
        storyGroups[currentGroupIndex][currentStoryIndex].isLiked.toggle()
        // TODO: persist story as liked
    }

    func close() {
        stopTimer()
    }
}

private extension StoryPlayerViewModelImpl {
    
    private func advanceToNextGroup() {
        stopTimer()
        guard currentGroupIndex < storyGroups.count - 1 else { return }
        currentGroupIndex += 1
        currentStoryIndex = 0
        resetProgress(for: currentGroupIndex)
        markCurrentAsSeen()
        startTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            progress[currentStoryIndex] += 0.05 / storyDuration
            if progress[currentStoryIndex] >= 1.0 {
                progress[currentStoryIndex] = 1.0
                Task { await self.advance() }
            }
        }
    }

    private func restartTimer() {
        for i in currentStoryIndex..<currentStories.count {
            progress[i] = 0
        }
        markCurrentAsSeen()
        startTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateProgressBars() {
        for i in 0..<currentStoryIndex {
            progress[i] = 1.0
        }
    }
    
    private func resetFutureProgress() {
        for i in currentStoryIndex..<currentStories.count {
            progress[i] = 0.0
        }
    }

    private func resetProgress(for index: Int) {
        let count = storyGroups[index].count
        progress = Array(repeating: 0, count: count)
    }

    private func markCurrentAsSeen() {
        guard !currentStory.isSeen else { return }
        print("Marking as seen: \(currentStory.id)")
        storyGroups[currentGroupIndex][currentStoryIndex].isSeen = true
        // TODO: persist story as seen
    }
}
