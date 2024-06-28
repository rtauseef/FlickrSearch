//
//  DetailView.swift
//  FlickrSearch
//
//  Created by Tauseef Riasat on 6/27/24.
//

import SwiftUI

struct DetailView: View {
    let item: FlickrItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = URL(string: item.media.m) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Color.gray
                        .frame(height: 200)
                }
                Text(item.title)
                    .font(.headline)
                    .padding(.top)
                Text("Author: \(item.author)")
                    .font(.subheadline)
                    .padding(.top)
                Text("Published: \(item.published)")
                    .font(.subheadline)
                    .padding(.top)
                Text(item.description)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Image Details")
    }
}

