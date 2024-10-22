//
//  RocketLaunch.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//
import ComposableArchitecture
import SwiftUI

@Reducer
struct RocketLaunch {
  @ObservableState
  struct State: Equatable {
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


struct RocketLaunchView: View {
  @Bindable var store: StoreOf<RocketLaunch>
  
  var body: some View {
    Form {
    }
    .navigationTitle("Launch")
  }
}
