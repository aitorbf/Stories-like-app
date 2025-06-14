//
//  StoryPlayerView.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import SwiftUI

struct StoryPlayerView<ViewModel: StoryPlayerViewModel>: View {
    
    @StateObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                AsyncImage(url: viewModel.currentStory.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } placeholder: {
                    Color.black
                }
                
                HStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.goBack()
                        }
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.advance()
                        }
                }
                .ignoresSafeArea()
                
                VStack(spacing: .zero) {
                    HStack(spacing: 4) {
                        ForEach(viewModel.progress.indices, id: \.self) { index in
                            ProgressView(value: min(viewModel.progress[index], 1.0))
                                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.close()
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding()
                        }
                        .padding(.trailing)
                    }
                    
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.toggleLike()
                }) {
                    Image(systemName: viewModel.currentStory.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(viewModel.currentStory.isLiked ? .red : .white)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .padding(.trailing)
            }
        }
        .background(.black)
    }
}
