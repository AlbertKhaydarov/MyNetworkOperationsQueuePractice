//
//  ImagesLoader.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//

import Foundation

protocol ImagesLoading {
    func loadImages(handler: @escaping (Result<ResponseModel, Error>) -> Void)
}

struct ImagesLoader: ImagesLoading {
    
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var getImagesUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api/"
        return components.url
    }
    
    func loadImages(handler: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        guard let url = getImagesUrl else {return handler(.failure(NetworkError.invalidURL))}
        
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let imagesFromSite = try JSONDecoder().decode(ResponseModel.self, from: data)
                    handler(.success(imagesFromSite))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
