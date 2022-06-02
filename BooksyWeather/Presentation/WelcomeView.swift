//
//  WelcomeView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 01/06/2022.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var showWelcomeView: Bool

    init() {
        _showWelcomeView = State(initialValue: UserDefaultsConfig.showWelcomeView)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 41/255, green: 44/255, blue: 51/255).ignoresSafeArea()

            Toggle("Show welcome again?", isOn: $showWelcomeView)
                .tint(.purple)
                .foregroundColor(.white)
                .padding([.bottom, .horizontal])
                .zIndex(10)

            VStack {
                Text("Welcome to Booksy Weather")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding(40)
                Text("1st choice weather app")
                    .foregroundColor(.white)
                    .font(.title)

                Spacer()

                Text("Tap anywhere to continue")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .contentShape(Rectangle())
            .padding(.top, 60)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: showWelcomeView) { value in
            UserDefaultsConfig.showWelcomeView = value
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
