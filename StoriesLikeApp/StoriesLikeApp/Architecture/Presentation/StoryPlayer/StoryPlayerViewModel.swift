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
    
    func advance() async
    func goBack() async
    func toggleLike() async
    func close() async
}

final class StoryPlayerViewModelImpl: StoryPlayerViewModel {
    
    @Published var storyGroups: [[Story]]
    @Published var currentGroupIndex: Int
    @Published var currentStoryIndex: Int
    @Published var progress: [CGFloat]
    
    private let storyDuration: TimeInterval = 10
    private var timer: Timer?
    private let markStoryAsSeenUseCase: MarkStoryAsSeenUseCase
    private let toggleStoryLikeUseCase: ToggleStoryLikeUseCase

    init(
        storyGroups: [[Story]],
        startGroup: Int = 0,
        markStoryAsSeenUseCase: MarkStoryAsSeenUseCase,
        toggleStoryLikeUseCase: ToggleStoryLikeUseCase
    ) {
        self.storyGroups = storyGroups
        self.currentGroupIndex = startGroup
        self.currentStoryIndex = 0
        self.progress = Array(repeating: 0, count: storyGroups[startGroup].count)
        self.markStoryAsSeenUseCase = markStoryAsSeenUseCase
        self.toggleStoryLikeUseCase = toggleStoryLikeUseCase
        
        Task {
            await markCurrentAsSeen()
        }
        startTimer()
    }

    var currentStories: [Story] { storyGroups[currentGroupIndex] }
    var currentStory: Story { currentStories[currentStoryIndex] }

    @MainActor
    func advance() async {
        stopTimer()
        progress[currentStoryIndex] = 1.0

        if currentStoryIndex < currentStories.count - 1 {
            currentStoryIndex += 1
        } else {
            await advanceToNextGroup()
            return
        }

        await markCurrentAsSeen()
        updateProgressBars()
        resetFutureProgress()
        startTimer()
    }

    @MainActor
    func goBack() async {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            await restartTimer()
        } else if currentGroupIndex > 0 {
            currentGroupIndex -= 1
            currentStoryIndex = storyGroups[currentGroupIndex].count - 1
            resetProgress(for: currentGroupIndex)
            updateProgressBars()
            await markCurrentAsSeen()
            await restartTimer()
        }
    }

    @MainActor
    func toggleLike() async {
        storyGroups[currentGroupIndex][currentStoryIndex].isLiked.toggle()
        try? await toggleStoryLikeUseCase.execute(storyGroups[currentGroupIndex][currentStoryIndex].id)
    }

    @MainActor
    func close() {
        stopTimer()
    }
}

private extension StoryPlayerViewModelImpl {
    
    @MainActor
    private func advanceToNextGroup() async {
        stopTimer()
        guard currentGroupIndex < storyGroups.count - 1 else { return }
        currentGroupIndex += 1
        currentStoryIndex = 0
        resetProgress(for: currentGroupIndex)
        await markCurrentAsSeen()
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

    @MainActor
    private func restartTimer() async  {
        for i in currentStoryIndex..<currentStories.count {
            progress[i] = 0
        }
        await markCurrentAsSeen()
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

    @MainActor
    private func resetProgress(for index: Int) {
        let count = storyGroups[index].count
        progress = Array(repeating: 0, count: count)
    }

    @MainActor
    private func markCurrentAsSeen() async {
        guard !currentStory.isSeen else { return }
        storyGroups[currentGroupIndex][currentStoryIndex].isSeen = true
        try? await markStoryAsSeenUseCase.execute(storyGroups[currentGroupIndex][currentStoryIndex].id)
    }
}
