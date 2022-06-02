//
//  LabeledTextField.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import SwiftUI

public struct LabeledTextField: View {
    @Binding var text: String

    var label: LocalizedStringKey
    var systemIcon: String = ""
    var icon: String = ""
    var showClearButton = true
    var onCommit: () -> Void
    var disabled: Bool
    var errorDescription: String

    var localizedErrorDescription: LocalizedStringKey {
        LocalizedStringKey(errorDescription)
    }

    @State var animate = false

    public init(text: Binding<String>,
                label: LocalizedStringKey,
                systemIcon: String = "",
                icon: String = "",
                showClearButton: Bool = true,
                onCommit: (() -> Void)? = nil,
                disabled: Bool = false,
                errorDescription: String = "") {
        self._text = text
        self.label = label
        self.systemIcon = systemIcon
        self.icon = icon
        self.showClearButton = showClearButton
        self.onCommit = onCommit ?? {}
        self.disabled = disabled
        self.errorDescription = errorDescription
    }

    public var body: some View {
        HStack(alignment: .bottom) {
            Group {
                if !systemIcon.isEmpty {
                    Image(systemName: systemIcon)
                        .padding(.bottom, !errorDescription.isEmpty ? 20 : 5)
                }

                if !icon.isEmpty {
                    Image(icon)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.bottom, 2.5)
                }
            }
            .foregroundColor(!errorDescription.isEmpty ? .red : .accentColor)
            .frame(width: 30, height: 30)
            .padding(.trailing, 10)


            VStack(alignment: .leading, spacing: 0) {
                if !animate {
                    Text(label)
                        .font(.caption.bold())
                        .foregroundColor(!errorDescription.isEmpty ? .red : .secondary)
                        .transition(.opacity)
                        .zIndex(1)
                }

                TextField("", text: $text, onCommit: onCommit)
                    .background(Text(label)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .opacity(text.isEmpty ? 1 : 0))
                    .overlay(clearButton, alignment: .trailing)
                    .padding(.bottom, 2)
                    .border(width: 0.5, edges: [.bottom], color: !errorDescription.isEmpty ? .red : .accentColor)
                    .disabled(disabled)

                if !errorDescription.isEmpty {
                    Text(localizedErrorDescription)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            animate = text.isEmpty
        }
        .onChange(of: text) { text in
            withAnimation(Animation.easeInOut) {
                animate = text.isEmpty
            }
        }
    }

    var clearButton: some View {
        Group {
            if !disabled {
                Image(systemName: "xmark")
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .opacity(animate ? 0 : 1)
                    .animation(Animation.easeInOut, value: animate)
                    .onTapGesture {
                        withAnimation {
                            text.removeAll()
                        }
                    }
            }
        }
    }
}
