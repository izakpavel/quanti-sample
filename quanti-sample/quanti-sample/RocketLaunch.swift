//
//  RocketLaunch.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//
import ComposableArchitecture
import SwiftUI
import CoreMotion
import Combine

// MARK: Simple motion manager

class MotionManager {
    private var motionManager = CMMotionManager()
    
    let pitchSubject: PassthroughSubject<Double, Never> = .init()

    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                guard let motion = motion else { return }
                
                // Example: Detect device movement based on pitch angle
                let pitch = motion.attitude.pitch
                self.pitchSubject.send (pitch)  // Adjust the threshold as needed
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}


// MARK: Reducer

@Reducer
struct RocketLaunch {
  
    let motion = MotionManager()
    
    @ObservableState
    struct State: Equatable {
        var isLaunched = false
        var imageName = "Rocket Idle"
    }
  
    public enum Action {
        case startMotionUpdates
        case stopMotionUpdates
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
                
                case .startMotionUpdates:
                self.motion.startMotionUpdates()
                    return .publisher {
                        motion.pitchSubject
                            .map { value in
                                return value < 0.2 ? .land : .launch
                            }
                      }
                
                case .stopMotionUpdates:
                self.motion.stopMotionUpdates()
                return .none
            }
        }
    }
}

// MARK: VIEWS

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
          
            Text(store.isLaunched ? "Launch successful!" : "Move your phone up to launch the rocket")
                .font(.headline)
                .padding()
      }// VSTack
      .onAppear {
          // Start motion updates when the view appears
          store.send(.startMotionUpdates)
      }
      .onDisappear{
          store.send(.stopMotionUpdates)
      }
      .navigationTitle("Launch")
  }
}
