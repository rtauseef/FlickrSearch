//
//  FlickrViewModel.swift
//  FlickrSearch
//
//  Created by Tauseef Riasat on 6/27/24.
//

import Foundation
import Combine
import SwiftUI

class FlickrViewModel: ObservableObject {
    @Published var items = [FlickrItem]()
    @Published var isLoading = false
    @Published var searchText: String = ""
    var lastKeyword = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init() {
        self.debounceTextChanges()
    }
    
    private func debounceTextChanges() {
        
        $searchText
        // 2 second debounce
            .debounce(for: 1, scheduler: RunLoop.main)
        
        // Called after 2 seconds when text stops updating (stoped typing)
            .sink {
                if self.lastKeyword == $0 { return }
                if $0.isEmpty == false {
                    self.isLoading = true
                }
                print("new text value: \($0)")
                self.fetchImages(for: $0)
            }
            .store(in: &cancellables)
    }
    
    func fetchImages(for tags: String) {
        guard !tags.isEmpty && lastKeyword != tags else {
            self.items = []
            return
        }
        lastKeyword = tags
        isLoading = true
        let tagsString = tags.replacingOccurrences(of: " ", with: ",")
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tagsString)"
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching images: \(error)")
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { response in
                self.items = response.items
            })
            .store(in: &self.cancellables)
    }
}
