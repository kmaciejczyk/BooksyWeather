//
//  WelcomeView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 01/06/2022.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(red: 41/255, green: 44/255, blue: 51/255).ignoresSafeArea()

        VStack {
            Text("Welcome to Booksy Weather")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(50)
            Text("1st choice weather app")
                .foregroundColor(.white)
                .font(.title)
            Spacer()
            Text("Tap anywhere to continue")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
        .padding(.top, 40)
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
