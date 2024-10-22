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
            
            RocketStageView(stage: store.rocket.firstStage)
                .withAddedTitle("First Stage")
            
            RocketStageView(stage: store.rocket.secondStage)
                .withAddedTitle("Second Stage")
            
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
            Text(value).font(.title2.weight(.bold))
            Text(title).font(.body.weight(.medium))
        }
        .foregroundStyle(Color.white)
        .withRoundedBackground(color: .accentColor)
    }
}

struct RocketStageView: View {
    let stage: RocketStageDisplayable
    var body: some View {
        VStack(spacing: AppConstants.spacing/2) {
            RocketStageLineView(icon: "Reusable", text: stage.formattedReusability)
            RocketStageLineView(icon: "Engine", text: stage.formattedEngines)
            RocketStageLineView(icon: "Fuel", text: stage.formattedFuelAmount)
            RocketStageLineView(icon: "Burn", text: stage.formattedBurnTime)
        }
        .withRoundedBackground(color: .secondary.opacity(0.2))
    }
}

struct RocketStageLineView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppConstants.spacing) {
            Image(icon)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
