//
//  MeasureGeometry.swift
//  quanti-sample
//
//  Created by Pavel Zak on 22.10.2024.
//

import SwiftUI

struct FrameMeasurePreferenceKey: PreferenceKey {
    typealias Value = [String: CGRect]

    static var defaultValue: Value = Value()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { current, new in
            new
        }
    }
}

struct MeasureGeometry: View {
    let space: CoordinateSpace
    let identifier: String
    // this dummy view will measure the view and store its width to preference value
    var body: some View {
        GeometryReader { geometry in
            ClearView()
                .preference(key: FrameMeasurePreferenceKey.self, value: [identifier: geometry.frame(in: space)])
        }
    }
}

struct ClearView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
    }
}

struct MeasureFrameViewModifier: ViewModifier {
    @Binding var frame: CGRect
    let space: CoordinateSpace

    func body(content: Content) -> some View {
        content.background(
            MeasureGeometry(space: self.space, identifier: "myFrame")
        )
        .onPreferenceChange(FrameMeasurePreferenceKey.self) {
            guard let frame = $0["myFrame"] else { return }
            self.frame = frame
        }
    }
}

extension View {
    func getFrame(_ frame: Binding<CGRect>, space: CoordinateSpace) -> some View {
        modifier(MeasureFrameViewModifier(frame: frame, space: space))
    }
}
