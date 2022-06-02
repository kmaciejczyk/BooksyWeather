//
//  SearchView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()

    @State var city = ""
    @State var state = ""
    @State var country = ""
    
    @Binding var tab: Tab
    @Binding var exportedColor: Color

    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }

    var body: some View {
        ZStack {
            exportedColor.opacity(0.1).ignoresSafeArea()

            VStack(alignment: .leading) {
                VStack {
                    Text("Where would you like to check the weather?")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Group {
                        LabeledTextField(text: $city, label: "City")
                        LabeledTextField(text: $state, label: "State code (US only)")
                        LabeledTextField(text: $country, label: "Country code")
                    }
                    .padding(.bottom, 6)
                    HStack {
                        Spacer()
                        clearButton
                        Spacer()
                        searchButton
                        Spacer()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
                .padding()

                if !viewModel.results.isEmpty {
                    resultList
                }

                Spacer()
            }
        }
    }

    var clearButton: some View {
        Button(action: {
            withAnimation {
                city.removeAll()
                state.removeAll()
                country.removeAll()
            }
        }) {
            Text("Clear")
                .frame(width: 100)
        }
        .tint(.red.opacity(0.8))
    }

    var searchButton: some View {
        Button(action: {
            viewModel.geocodeCity(city: city, state: state, country: country)
        }) {
            if viewModel.inProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 100)
            } else {
                Text("Search")
                    .frame(width: 100)
            }
        }
        .disabled(viewModel.inProgress)
    }
    
    var resultList: some View {
        VStack {
            HStack {
                Image(systemName: "info.circle")
                Text("Tap on city name to check it's weather")
            }
            .foregroundColor(.secondary)
            .font(.caption.weight(.bold))
            .padding(.horizontal)

            List {
                ForEach(viewModel.results) { city in
                    Button(action: {
                        tab = .currentWeather
                        viewModel.saveCity(city)
                    }) {
                        Text("\(city.name), \(city.country)")
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tab: .constant(.cityChoice), exportedColor: .constant(.orange))
    }
}
