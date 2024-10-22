//
//  RokcetList.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct RocketList {
    @ObservableState
    struct State {
        var rockets: [Rocket]
        var isLoading = false
        var error: Error?
    }
  
    enum Action {
        case load
        case loadResponse([Rocket], Error?)
        case openDetail(rocket: Rocket)
    }
  
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.rockets = []
                state.isLoading = true
                return .run { send in
                    do {
                        let (data, _) = try await URLSession.shared
                            .data(from: URL(string: "https://api.spacexdata.com/v3/rockets")!)
                        let rockets = try JSONDecoder().decode([Rocket].self, from: data)
                        await send(.loadResponse(rockets, nil))
                    }
                    catch {
                        await send(.loadResponse([], error))
                    }
                }
        
            case .loadResponse(let rockets, let error):
                state.rockets = rockets
                state.isLoading = false
                state.error = error
                return .none
            
            case .openDetail(let rocket):
                return .none
      }
    }
  }
}

struct RocketListView: View {
  let store: StoreOf<RocketList>
  
    var body: some View {
        List {
            ForEach (store.rockets) { rocket in
                Text(rocket.rocketName)
            }
        }
        .overlay {
            if store.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }
            else if let error = store.error {
                Text(error.localizedDescription)
            }
        }
        .onAppear{
            store.send(.load)
        }
    }
}
