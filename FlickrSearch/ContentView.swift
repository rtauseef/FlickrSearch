//
//  ContentView.swift
//  FlickrSearch
//
//  Created by Tauseef Riasat on 6/27/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var searchText = "" //"porcupine"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    TextField("Search", text: $viewModel.searchText)
                    .submitLabel(.search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disableAutocorrection(true)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.trailing)
                    }
                }
                
                if viewModel.items.isEmpty {
                    Text("Search result will appear here")
                }
                
                List(viewModel.items) { item in
                    HStack {
                        NavigationLink(destination: DetailView(item: item)) {
                            if let url = URL(string: item.media.m) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 100, height: 100)
                                }
                                Text(item.title)
                            } else {
                                Text("Invalid URL: \(item.media.m)")
                                Color.gray
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
