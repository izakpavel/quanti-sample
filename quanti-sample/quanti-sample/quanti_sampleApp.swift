//
//  quanti_sampleApp.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct quanti_sampleApp: App {
    static let store = Store(initialState: RocketList.State(rockets: [])) {
        RocketList()
          ._printChanges()
      }
    
    var body: some Scene {
        WindowGroup {
            RocketListView(store: quanti_sampleApp.store)
        }
    }
}
