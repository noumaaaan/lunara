//
//  CustomTabView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import SwiftUI

private enum Constants {
    static let barHeight: CGFloat = 74
    static let horizontalPadding: CGFloat = 20
    static let outerHorizontalInset: CGFloat = 20
    static let bottomInset: CGFloat = 12

    static let barCornerRadius: CGFloat = 24
    static let selectedPillCornerRadius: CGFloat = 18

    static let selectedPillWidth: CGFloat = 90
    static let selectedPillHeight: CGFloat = 55

    static let iconSize: CGFloat = 22
    static let selectedIconScale: CGFloat = 1.08
    static let selectedIconYOffset: CGFloat = -1

    static let barBackground = Color(red: 29 / 255, green: 47 / 255, blue: 71 / 255)
    static let selectedTint = Color(red: 178 / 255, green: 200 / 255, blue: 235 / 255)
    static let unselectedTint = Color(red: 127 / 255, green: 138 / 255, blue: 157 / 255)

    static let selectedPillColor = Color.white.opacity(0.10)
    static let selectedPillBorder = Color.white.opacity(0.07)
    static let borderColor = Color.white.opacity(0.08)
    static let shadowColor = Color.black.opacity(0.18)

    static let selectionSpring = Animation.spring(response: 0.34, dampingFraction: 0.82)
    static let iconSpring = Animation.spring(response: 0.28, dampingFraction: 0.88)
}

struct CustomTabView: View {
    @Binding var selectedTab: TabOption
    @Namespace private var selectionAnimation

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TabOption.allCases, id: \.self) { tab in
                Button {
                    guard selectedTab != tab else { return }
                    withAnimation(Constants.selectionSpring) {
                        selectedTab = tab
                    }
                } label: {
                    ZStack {
                        if tab == selectedTab {
                            RoundedRectangle(
                                cornerRadius: Constants.selectedPillCornerRadius,
                                style: .continuous
                            )
                            .fill(Constants.selectedPillColor)
                            .overlay {
                                RoundedRectangle(
                                    cornerRadius: Constants.selectedPillCornerRadius,
                                    style: .continuous
                                )
                                .stroke(Constants.selectedPillBorder, lineWidth: 1)
                            }
                            .frame(
                                width: Constants.selectedPillWidth,
                                height: Constants.selectedPillHeight
                            )
                            .matchedGeometryEffect(id: "selectedTabBackground", in: selectionAnimation)
                        }

                        Image(tab.image)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                            .foregroundStyle(tab == selectedTab ? Constants.selectedTint : Constants.unselectedTint)
                            .scaleEffect(tab == selectedTab ? Constants.selectedIconScale : 1)
                            .offset(y: tab == selectedTab ? Constants.selectedIconYOffset : 0)
                            .animation(Constants.iconSpring, value: selectedTab)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(height: Constants.barHeight)
        .background(
            RoundedRectangle(cornerRadius: Constants.barCornerRadius, style: .continuous)
                .fill(Constants.barBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.barCornerRadius, style: .continuous)
                        .stroke(Constants.borderColor, lineWidth: 1)
                }
                .shadow(color: Constants.shadowColor, radius: 18, x: 0, y: 10)
        )
        .padding(.horizontal, Constants.outerHorizontalInset)
        .padding(.bottom, Constants.bottomInset)
    }
}

// Preview wrapper
private struct CustomTabViewPreviewWrapper: View {
    @State private var selectedTab: TabOption = .log

    var body: some View {
        ZStack {
            Color(red: 17 / 255, green: 37 / 255, blue: 60 / 255)
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
