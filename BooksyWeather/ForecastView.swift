//
//  ForecastView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct ForecastView: View {
    @Binding var tab: Tab
    @Binding var exportedColor: Color

    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(tab: .constant(.forecast), exportedColor: .constant(.orange))
    }
}
