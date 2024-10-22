//
//  RokcetList.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//
import ComposableArchitecture
import Foundation
import SwiftUI

// MARK: - RocketsProvider

struct RocketsProvider {
    var fetch: () async throws -> ([Rocket])
}

extension RocketsProvider: DependencyKey {
    
    static let liveValue = Self(
        fetch: {
            let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://api.spacexdata.com/v3/rockets")!)
            let rockets = try JSONDecoder().decode([Rocket].self, from: data)
            return rockets
        }
    )
}


extension DependencyValues {
  var rocketsProvider: RocketsProvider {
    get { self[RocketsProvider.self] }
    set { self[RocketsProvider.self] = newValue }
  }
}

// MARK: - RocketList

@Reducer
struct RocketList {
    @Reducer(state: .equatable)
    enum Destination {
        case rocketDetail(RocketDetail)
        case rocketLaunch(RocketLaunch)
    }
    
    @ObservableState
    struct State {
        var rockets: [Rocket]
        var isLoading = false
        var error: Error?
        var path = StackState<Destination.State>()
    }
  
    enum Action {
        case load
        case loadResponse([Rocket], Error?)
        case openDetail(rocket: Rocket)
        case openLaunch
        case path(StackAction<Destination.State, Destination.Action>)
    }
    
    @Dependency(\.rocketsProvider) var rocketsProvider
  
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.rockets = []
                state.isLoading = true
                return .run { send in
                    do {
                        let rockets = try await rocketsProvider.fetch()
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
                state.path.append(.rocketDetail(RocketDetail.State(rocket: rocket)))
                return .none
            
            case .openLaunch:
                state.path.append(.rocketLaunch(RocketLaunch.State()))
                return .none
                
            case .path(_):
                return .none
            }
        }.forEach(\.path, action: \.path) 
    }
}

// MARK: - RocketListView

struct RocketListView: View {
    @Bindable var store: StoreOf<RocketList>
  
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                ForEach (store.rockets) { rocket in
                    //NavigationLink(state: RocketList.Destination.rocketDetail(RocketDetail())) {//RocketDetail.State(rocket: rocket)) {
                        RocketListItemView(rocket: rocket)
                        .onTapGesture {
                            store.send(.openDetail(rocket: rocket))
                        }
                    //}
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
            .navigationTitle("Rockets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.send(.openLaunch)
                    }) {
                        Text("Launch")
                    }
                }
            }
                            
        } destination: { state in
            switch state.case {
            case .rocketDetail(let store):
                RocketDetailView(store: store)
            case .rocketLaunch(let store):
                RocketLaunchView(store: store)
            }
        }
    }
}


struct RocketListItemView: View {
    let rocket: Rocket
    var body: some View {
        HStack(spacing: 16) {
            Image("RocketIcon")
            VStack(alignment: .leading) {
                Text(rocket.rocketName).font(.headline)
                Text("First flight: \(rocket.firstFlight)").font(.footnote).foregroundStyle(.secondary)
            }
        }
    }
}
