//
//  IntroView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-05.
//

import SwiftUI

struct IntroView: View {
    @State private var selectedItem: IntroItem = introItems.first!
    @State private var items: [IntroItem] = introItems
    @State private var activeIndex: Int = 0
    
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                Button {
                    updateItem(isForward: false)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.cardGradientEnd.gradient)
                        .contentShape(.rect)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(selectedItem.id != items.first?.id ? 1 : 0)
                
                ZStack {
                    ForEach(items) {item in
                        AnimatedIconView(item)
                    }
                }
                .frame(height: 250)
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        ForEach(items) {item in
                            Capsule()
                                .fill(selectedItem.id == item.id ? .primaryText : .gray)
                                .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                        }
                    }
                    .padding(.bottom, 15)
                    
                    Text(selectedItem.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .contentTransition(.numericText())
                        .foregroundColor(.primaryText)
                }
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                
                Button {
                    if selectedItem.id == items.last?.id {
                        authViewModel.completeIntro()
                    }
                    updateItem(isForward: true)
                } label: {
                    Text(selectedItem.id == items.last?.id ? "Fortsätt" : "Nästa")
                        .contentTransition(.numericText())
                }
                .modifier(ButtonModifier())
                .padding(.bottom, 25)
            }
        }
        .gradientBackground()
        
    }
    
    @ViewBuilder
    func AnimatedIconView(_ item: IntroItem) -> some View {
        let isSelected = selectedItem.id == item.id
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.primaryText.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.cardGradientMid.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.cardGradientEnd.opacity(0.5))
                    .shadow(color: .primaryText.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primaryText.opacity(0.2), radius: 1, x: -1, y: -1)
                    .padding(-3)
                    .opacity(selectedItem.id == item.id ? 1 : 0)
                
            }
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.init(degrees: item.rotation))
            .zIndex(isSelected ? 2 : item.zindex)
    }
    
    func updateItem(isForward: Bool) {
        guard isForward ? activeIndex != items.count - 1 : activeIndex != 0 else { return }
        
        
        var fromIndex: Int
        var extraOffset: CGFloat
        
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
        
        
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = items[activeIndex].extraOffset
        } else {
            fromIndex = activeIndex + 1
            extraOffset = items[activeIndex].extraOffset
        }
        
        
        
        for index in items.indices {
            items[index].zindex = 0
        }
        Task { [fromIndex, extraOffset] in
            withAnimation(.bouncy(duration: 1)) {
                items[fromIndex].scale = items[activeIndex].scale
                items[fromIndex].rotation = items[activeIndex].rotation
                items[fromIndex].anchor = items[activeIndex].anchor
                items[fromIndex].offset = items[activeIndex].offset
                
                items[activeIndex].offset = extraOffset
                
                items[fromIndex].zindex = 1
                
            }
            
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.9)) {
                items[activeIndex].scale = 1
                items[activeIndex].rotation = .zero
                items[activeIndex].anchor = .center
                items[activeIndex].offset = .zero
                
                
                selectedItem = items[activeIndex]
            }
        }
    }
}

#Preview {
    IntroView()
        .environment(AuthViewModel())
}
