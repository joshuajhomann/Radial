//
//  ContentView.swift
//  Radial
//
//  Created by Joshua Homann on 6/11/22.
//

import SwiftUI

struct RadialLayout: Layout {
    var startAngle: Double = 0
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let delta = 2.0 * .pi / Double(subviews.count)
        let angles = sequence(first: startAngle) { $0 + delta }
        let radius = min(bounds.size.width, bounds.size.height) * 0.33
        zip(subviews, angles).forEach { (view, angle) in
            view.place(
                at: .init(
                    x: cos(angle) * radius + bounds.midX,
                    y: sin(angle) * radius + bounds.midY
                ),
                anchor: .center,
                proposal: .unspecified
            )
        }
    }


}

struct ContentView: View {
    private let colors = [#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)]
    private let imageNames = ["person", "aqi.medium", "seal", "heart", "touchid", "hand.raised"]
    var body: some View {
        TimelineView(.animation) { date in
            RadialLayout(startAngle: date.date.timeIntervalSince1970 * 0.25).callAsFunction({
                ForEach(colors.indices, id: \.self) { index in
                    Image(systemName: imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .background(in: Circle().inset(by: -40))
                        .backgroundStyle(Color(uiColor: colors[index]).gradient)
                        .foregroundStyle(Color.white.shadow(.drop(radius: 5.0)))
                        .frame(width: 125)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
