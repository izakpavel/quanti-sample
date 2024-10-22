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
        var isLaunched = false
        var imageName = "Rocket Idle"
    }
  
    enum Action {
        case launch
        case land
    }

    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .launch:
                  state.isLaunched = true
                  return .none
                case .land:
                  state.isLaunched = false
                  return .none
            }
        }
    }
}

struct RocketView: View, Animatable {
    var offset: CGFloat = 0 // 0..1
    @State var canvasFrame: CGRect = .zero
    let rocketHeight: CGFloat = 230
    
    var animatableData: CGFloat {
        get { return self.offset }
        set { self.offset = newValue }
    }
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image(offset > 0 ? "Rocket Flying" : "Rocket Idle")
                  .position(
                    x: canvasFrame.size.width/2,
                    y: canvasFrame.size.height - rocketHeight/2 - (offset)*(canvasFrame.size.height+200)
                  )
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .getFrame($canvasFrame, space: .global)
    }
}

struct RocketLaunchView: View {
    
    @Bindable var store: StoreOf<RocketLaunch>
    
    
    
  
    var body: some View {
        VStack() {
          
            RocketView(offset: store.isLaunched ? 1 : 0)
                .animation(.easeIn(duration: 2), value: store.isLaunched)
          
          
          Button(action: { store.send(.launch) } ) {
              Text("launch!")
          }.padding()
            
            Button(action: { store.send(.land) } ) {
                Text("land!")
            }.padding()
      }// VSTack
      .onAppear {
          // Start motion updates when the view appears
          //viewStore.send(.startMotionUpdates)
      }
      .navigationTitle("Launch")
  }
}
