//
//  DatePickerDialogView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let calendarCornerRadius: CGFloat = 18
    static let containerCornerRadius: CGFloat = 24
    static let verticalSpacing: CGFloat = 18
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 20
    static let buttonHeight: CGFloat = 48
    static let calendarHeight: CGFloat = 330
    static let dialogMaxWidth: CGFloat = 560
}

struct DatePickerDialogView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    @State private var draftDate: Date
    @State private var hasAppeared = false

    init(selectedDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self._draftDate = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            Text(
                draftDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year())
            )
            .font(LunaraFont.semiBoldBody)
            .foregroundStyle(LunaraColor.cream)
            .frame(maxWidth: .infinity, alignment: .center)

            DatePicker(
                "",
                selection: $draftDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(LunaraColor.cream)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: Constants.calendarHeight, alignment: .topLeading)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: Constants.calendarCornerRadius, style: .continuous)
                    .fill(LunaraColor.background.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.calendarCornerRadius, style: .continuous)
                            .stroke(LunaraColor.borderColor, lineWidth: 1)
                    }
            )

            HStack(spacing: 10) {
                CustomButton(
                    title: "Cancel",
                    style: .secondary,
                    height: Constants.buttonHeight
                ) {
                    dismiss()
                }

                CustomButton(
                    title: "Done",
                    style: .primary,
                    height: Constants.buttonHeight
                ) {
                    selectedDate = draftDate
                    dismiss()
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .frame(maxWidth: Constants.dialogMaxWidth)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Constants.containerCornerRadius, style: .continuous)
                .fill(LunaraColor.secondary)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.containerCornerRadius, style: .continuous)
                        .stroke(LunaraColor.borderColor, lineWidth: 1)
                }
        )
        .shadow(color: Color.black.opacity(0.28), radius: 20, x: 0, y: 12)
        .padding(.horizontal, 24)
        .scaleEffect(hasAppeared ? 1 : 0.96)
        .opacity(hasAppeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                hasAppeared = true
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.18)) {
            hasAppeared = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            isPresented = false
        }
    }
}

#Preview {
    DatePickerDialogViewPreviewWrapper()
}

private struct DatePickerDialogViewPreviewWrapper: View {
    @State private var selectedDate = Date()
    @State private var isPresented = true

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            Color.black.opacity(0.35)
                .ignoresSafeArea()

            if isPresented {
                DatePickerDialogView(
                    selectedDate: $selectedDate,
                    isPresented: $isPresented
                )
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}
