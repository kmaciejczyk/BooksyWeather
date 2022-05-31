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

    init(tab: Binding<Tab>) {
        _tab = tab
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Where would you like to check the weather?")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                Group {
                    LabeledTextField(text: $city, label: "City")
                    LabeledTextField(text: $state, label: "State code (US only)")
                    LabeledTextField(text: $country, label: "Country code")
                }
                .padding(.bottom, 6)
                HStack {
                    Spacer()
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
                    Spacer()
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
                    
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()

            if !viewModel.results.isEmpty {
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
                            Text("\(city.name) \(city.country)")
                        }
                    }
                }
                .listStyle(.plain)
            }

            Spacer()
        }

    }
}

struct CityChoice_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tab: .constant(.cityChoice))
    }
}

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

public extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top,
                        .bottom,
                        .leading:
                    return rect.minX
                case .trailing:
                    return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing:
                    return rect.minY
                case .bottom:
                    return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom:
                    return rect.width
                case .leading, .trailing:
                    return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom:
                    return width
                case .leading, .trailing:
                    return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }

        return path
    }
}
