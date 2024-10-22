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
    Form {
    }
    .navigationTitle(store.rocket.rocketName)
  }
}
