//
//  NetworkRouting.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//

import Foundation

enum NetworkError: Error {
    case codeError
    case invalidURL
}

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        
//        let httpHeaders = ["Key": "40591442-21fbfe5b7e9ff5e26d8c8c44c", "q": "yellow+flowers", "image_type" : "photo"]
        let httpHeaders = ["key": "40591442-21fbfe5b7e9ff5e26d8c8c44c"]
        request.allHTTPHeaderFields = httpHeaders
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                handler(.failure(error))
            }

            if let response = response as? HTTPURLResponse,
           
               response.statusCode < 200 || response.statusCode >= 300 {

                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {return}
            handler(.success(data))
        }
        
        task.resume()
    }
}
