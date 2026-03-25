//
//  SaveHUDView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct SaveHUDView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(LunaraColor.cream)

            Text(message)
                .font(LunaraFont.semiBoldBody)
                .foregroundStyle(LunaraColor.cream)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(LunaraColor.borderColor, lineWidth: 1)
                }
        )
        .shadow(color: Color.black.opacity(0.22), radius: 18, x: 0, y: 10)
    }
}

#Preview {
    ZStack {
        LunaraColor.background
            .ignoresSafeArea()

        Color.black.opacity(0.2)
            .ignoresSafeArea()

        SaveHUDView(message: "Dream saved")
    }
}
