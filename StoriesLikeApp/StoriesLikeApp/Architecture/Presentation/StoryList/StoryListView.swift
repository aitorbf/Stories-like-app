//
//  StoryListView.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import SwiftUI

struct StoryListView<ViewModel: StoryListViewModel>: View {
    
    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: .zero) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(.clear)
                                        .strokeBorder(
                                            user.stories.contains(where: { !$0.isSeen }) ?
                                                AnyShapeStyle(
                                                    LinearGradient(
                                                        colors: [Color.purple, Color.red, Color.orange, Color.yellow],
                                                        startPoint: .topTrailing,
                                                        endPoint: .bottomLeading
                                                    )
                                                )
                                                :
                                                AnyShapeStyle(Color.gray.opacity(0.3)),
                                            lineWidth: 3
                                        )
                                        .frame(width: 70, height: 70)

                                    AsyncImage(url: user.profilePictureURL) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.1)
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                }

                                Text(user.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            .frame(width: 70)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreStories(currentIndex: index)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }

                Spacer()
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
}
