//
//  RocketDetail.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct RocketDetail {
  @ObservableState
  struct State: Equatable {
    let rocket: Rocket
  }
    
  enum Action {
  }
    
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}


struct RocketDetailView: View {
  @Bindable var store: StoreOf<RocketDetail>
  
  var body: some View {
    ScrollView {
        VStack(spacing: AppConstants.spacing) {
            Text(store.rocket.description)
                .withAddedTitle("Overview")
            
            LazyVGrid(columns: (0...2).map{ _ in GridItem(.flexible()) }) {
                ParameterView(value: store.rocket.height.formattedMeters, title: "height")
                ParameterView(value: store.rocket.diameter.formattedMeters, title: "diameter")
                ParameterView(value: store.rocket.mass.formattedTons, title: "mass")
            }
            .withAddedTitle("Parameters")
            
            ForEach (store.rocket.flickrImages, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(AppConstants.cornerRadius)
                    } placeholder: {
                        ProgressView().progressViewStyle(CircularProgressViewStyle()) 
                    }
            }
            .withAddedTitle("Photos")
        }
        .padding()
    }
    .navigationTitle(store.rocket.rocketName)
  }
}

// MARK: helpers

struct ParameterView: View {
    let value: String
    let title: String
    var body: some View {
        VStack(spacing: AppConstants.spacing/2) {
            Text(value).font(.title.weight(.bold))
            Text(title).font(.body.weight(.medium))
        }
        .foregroundStyle(Color.white)
        .withRoundedBackground(color: .accentColor)
    }
}

extension View {
    func withAddedTitle(_ title: String) -> some View{
        return VStack(alignment: .leading, spacing: AppConstants.spacing/2) {
            Text(title).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
            self
        }
    }
    
    func withRoundedBackground(color: Color, padding: CGFloat = AppConstants.spacing, radius: CGFloat = AppConstants.cornerRadius) -> some View {
        return self
                .padding(padding)
                .background(RoundedRectangle(cornerRadius: radius).fill(color))
    }
}
