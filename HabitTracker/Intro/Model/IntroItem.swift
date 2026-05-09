//
//  IntroItem.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-05.
//

import Foundation
import SwiftUI
struct IntroItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    
    var extraOffset: CGFloat = -350
}

let introItems: [IntroItem] = [
    .init(
        image: "figure.run.circle.fill",
        title: "Följ koll på din träning",
        scale: 1
    ),
    .init(
        image: "wifi.slash",
        title: "Detoxa från sociala medier",
        scale: 0.6,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(image: "book.closed.circle.fill",
          title: "Uppdatera din läsningsförmåga",
          scale: 0.5,
          anchor: .bottomLeading,
          offset: -60,
          rotation: -35
         ),
    .init(image: "figure.cooldown.circle.fill",
          title: "Andas efter ett hårt pass",
          scale: 0.4,
          anchor: .bottomLeading,
          offset: -50,
          rotation: 160,
          extraOffset: -120
         ),
    .init(image: "chart.bar.yaxis",
          title: "Börja tracka dina vanor",
          scale: 0.35,
          anchor: .bottomLeading,
          offset: -50,
          rotation: 250,
          extraOffset: -100),
    
]
