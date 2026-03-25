//
//  CustomTabView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import SwiftUI

private enum Constants {
    // Layout
    static let selectedPillWidth: CGFloat = 80
    static let selectedPillHeight: CGFloat = 55
    static let iconSize: CGFloat = 22
    static let hstackPadding: CGFloat = 15
    static let hstackHeight: CGFloat = 80
    static let cornerRadius: CGFloat = 25
    static let tabButtonHeight: CGFloat = 52
    
    // Colours.
    static let tabShadowColor = LunaraColor.background.opacity(0.3)
    static let whiteReducedOpacity = LunaraColor.cream.opacity(0.1)
    static let selectedIconColor = LunaraColor.cream
    static let iconColor = LunaraColor.pink.opacity(0.45)
    
    // Animation.
    static let selectionSpring = Animation.spring(response: 0.5, dampingFraction: 0.9)
}

struct CustomTabView: View {
    @Binding var selectedTab: TabOption
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 10) {
            ForEach(TabOption.allCases, id: \.self) { tab in
                Button {
                    guard selectedTab != tab else { return }
                    withAnimation(Constants.selectionSpring) {
                        selectedTab = tab
                    }
                } label: {
                    ZStack {
                        if tab == selectedTab {
                            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                                .fill(Constants.whiteReducedOpacity)
                                .overlay {
                                    RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                                        .stroke(LunaraColor.borderColor, lineWidth: 1)
                            }
                            .frame(width: Constants.selectedPillWidth,height: Constants.selectedPillHeight)
                            .matchedGeometryEffect(id: "selectedTabBackground", in: namespace)
                        }

                        Image(tab.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                            .foregroundStyle(tab == selectedTab ? Constants.selectedIconColor : Constants.iconColor)
                            .scaleEffect(tab == selectedTab ? 1.2 : 1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.tabButtonHeight)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Constants.hstackPadding)
        .frame(height: Constants.hstackHeight)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .fill(LunaraColor.tabBarColor)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                        .stroke(LunaraColor.borderColor, lineWidth: 1)
                }
                .shadow(color: Constants.tabShadowColor, radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 5)
    }
}

// Preview wrapper
private struct CustomTabViewPreviewWrapper: View {
    @State private var selectedTab: TabOption = .log

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            VStack {
                Spacer()
                CustomTabView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    CustomTabViewPreviewWrapper()
}
