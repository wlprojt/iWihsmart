//
//  HomeView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            WishmartTopBar {
                print("Search tapped")
            }

            ScrollView {
                Text("Home content")
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
