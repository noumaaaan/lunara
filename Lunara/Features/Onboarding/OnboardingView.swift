//
//  OnboardingView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import SwiftUI

private enum Constants {
    static let screenPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 24
    static let buttonSpacing: CGFloat = 12
    static let nameFieldHeight: CGFloat = 52
}

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("displayName") private var displayName: String = ""

    @State private var currentStep: Int = 0
    @State private var isFinishing = false
    @State private var showFinishCard = false
    @State private var navigationDirection: CGFloat = 1
    @FocusState private var isNameFocused: Bool

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topProgress

                stepContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                bottomActions
            }

            if isFinishing {
                ZStack {
                    Color.black.opacity(0.42)
                        .ignoresSafeArea()

                    VStack(spacing: 14) {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 34, weight: .regular))
                            .foregroundStyle(LunaraColor.pink)
                            .scaleEffect(showFinishCard ? 1 : 0.82)
                            .opacity(showFinishCard ? 1 : 0)

                        Text(finishTitle)
                            .font(.manropeSemiBold(size: 24))
                            .foregroundStyle(LunaraColor.cream)
                            .opacity(showFinishCard ? 1 : 0)

                        Text("Your dream journal is ready.")
                            .font(LunaraFont.body)
                            .foregroundStyle(LunaraColor.cream.opacity(0.8))
                            .opacity(showFinishCard ? 1 : 0)
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                            .fill(LunaraColor.secondary.opacity(0.92))
                            .overlay {
                                RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                                    .stroke(LunaraColor.border, lineWidth: 1)
                            }
                    )
                    .shadow(color: LunaraShadow.color, radius: LunaraShadow.radius, x: 0, y: LunaraShadow.y)
                    .scaleEffect(showFinishCard ? 1 : 0.94)
                    .opacity(showFinishCard ? 1 : 0)
                }
                .transition(.opacity)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isNameFocused = false
        }
    }
}

private extension OnboardingView {
    var stepContent: some View {
        ZStack {
            switch currentStep {
            case 0:
                welcomeStep
                    .transition(stepTransition)
            case 1:
                introStep
                    .transition(stepTransition)
            case 2:
                nameStep
                    .transition(stepTransition)
            default:
                EmptyView()
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.9), value: currentStep)
    }

    var stepTransition: AnyTransition {
        let insertionEdge: Edge = navigationDirection > 0 ? .trailing : .leading
        let removalEdge: Edge = navigationDirection > 0 ? .leading : .trailing

        return .asymmetric(
            insertion: .move(edge: insertionEdge).combined(with: .opacity),
            removal: .move(edge: removalEdge).combined(with: .opacity)
        )
    }

    var topProgress: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? LunaraColor.cream : LunaraColor.cream.opacity(0.18))
                    .frame(width: 35, height: 6)
                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: currentStep)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    var welcomeStep: some View {
        VStack(spacing: Constants.sectionSpacing) {
            Spacer()

            VStack(spacing: 18) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(LunaraColor.pink)

                VStack(spacing: 12) {
                    Text("Welcome to Lunara")
                        .font(.manropeSemiBold(size: 30))
                        .foregroundStyle(LunaraColor.cream)
                        .multilineTextAlignment(.center)

                    Text("A calm place to capture dreams, revisit them later, and notice patterns over time.")
                        .font(LunaraFont.body)
                        .foregroundStyle(LunaraColor.cream.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .transition(.opacity.combined(with: .offset(y: 12)))

            Spacer()
        }
        .padding(.horizontal, Constants.screenPadding)
    }

    var introStep: some View {
        VStack(spacing: Constants.sectionSpacing) {
            Spacer()

            VStack(spacing: 16) {
                onboardingCard(
                    icon: "square.and.pencil",
                    title: "Log quickly",
                    body: "Write your dream down before it fades."
                )

                onboardingCard(
                    icon: "calendar",
                    title: "Browse by date",
                    body: "Revisit dreams through your journal and calendar."
                )

                onboardingCard(
                    icon: "chart.bar.fill",
                    title: "Spot patterns",
                    body: "See moods, categories, and activity trends over time."
                )
            }
            .transition(.opacity.combined(with: .offset(y: 12)))

            Spacer()
        }
        .padding(.horizontal, Constants.screenPadding)
    }

    var nameStep: some View {
        VStack(spacing: Constants.sectionSpacing) {
            Spacer()

            VStack(spacing: 12) {
                Text("What should we call you?")
                    .font(.manropeSemiBold(size: 28))
                    .foregroundStyle(LunaraColor.cream)
                    .multilineTextAlignment(.center)

                Text("This helps make Lunara feel a little more personal.")
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
            }

            CustomTextField(
                text: $displayName,
                placeholder: "Enter your name",
                height: Constants.nameFieldHeight,
                isFocused: $isNameFocused
            )
            .padding(.top, 4)

            Spacer()
        }
        .padding(.horizontal, Constants.screenPadding)
        .offset(y: isNameFocused ? -24 : 0)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isNameFocused)
    }

    var bottomActions: some View {
        VStack(spacing: Constants.buttonSpacing) {
            primaryActionButton

            secondaryActionButton
                .opacity(currentStep > 0 ? 1 : 0)
                .offset(y: currentStep > 0 ? 0 : 6)
                .allowsHitTesting(currentStep > 0)
        }
        .padding(.horizontal, Constants.screenPadding)
        .padding(.bottom, 24)
        .padding(.top, 8)
        .opacity(isFinishing ? 0 : 1)
        .allowsHitTesting(!isFinishing)
        .animation(.spring(response: 0.34, dampingFraction: 0.92), value: currentStep)
    }

    @ViewBuilder
    var primaryActionButton: some View {
        if currentStep < 2 {
            CustomButton(
                title: "Continue",
                style: .primary,
                height: 56
            ) {
                goToNextStep()
            }
        } else {
            CustomButton(
                title: "Get Started",
                style: .primary,
                height: 56,
                isDisabled: trimmedDisplayName.isEmpty
            ) {
                finishOnboarding()
            }
        }
    }

    var secondaryActionButton: some View {
        CustomButton(
            title: "Back",
            style: .secondary,
            height: 50
        ) {
            goToPreviousStep()
        }
    }

    func onboardingCard(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(LunaraColor.pink)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(LunaraColor.cream)

                Text(body)
                    .font(LunaraFont.bodySmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }

    var finishTitle: String {
        trimmedDisplayName.isEmpty ? "Welcome to Lunara" : "Welcome, \(trimmedDisplayName)"
    }

    var trimmedDisplayName: String {
        displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func goToNextStep() {
        guard currentStep < 2 else { return }
        isNameFocused = false
        navigationDirection = 1

        withAnimation(.spring(response: 0.42, dampingFraction: 0.9)) {
            currentStep += 1
        }
    }

    func goToPreviousStep() {
        guard currentStep > 0 else { return }
        isNameFocused = false
        navigationDirection = -1

        withAnimation(.spring(response: 0.42, dampingFraction: 0.9)) {
            currentStep -= 1
        }
    }

    func finishOnboarding() {
        displayName = trimmedDisplayName
        isNameFocused = false

        withAnimation(.easeInOut(duration: 0.2)) {
            isFinishing = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                showFinishCard = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.35)) {
                hasCompletedOnboarding = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}
