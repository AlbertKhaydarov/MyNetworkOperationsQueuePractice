//
//  ImagesLoader.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//

import Foundation

protocol ImagesLoadingProtocol {
    func loadImages(handler: @escaping (Result<ResponseModel, Error>) -> Void)
}

struct ImagesLoader: ImagesLoadingProtocol {
    
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
        components.queryItems = [
        URLQueryItem(name: "key", value: "40591442-21fbfe5b7e9ff5e26d8c8c44c"),
        URLQueryItem(name: "q", value: "towns"),
        URLQueryItem(name: "image_type", value: "photo")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components.url
    }
    
    func loadImages(handler: @escaping (Result<ResponseModel, Error>) -> Void) {
        guard let url = getImagesUrl else {return handler(.failure(NetworkError.invalidURL))}

        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let imagesFromSite = try decoder.decode(ResponseModel.self, from: data)
                  
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
