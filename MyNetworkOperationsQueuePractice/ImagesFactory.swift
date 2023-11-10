//
//  ImagesFactory.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//



import Foundation
protocol ImagesFactoryProtocol {
    func requestImages()
    func loadData()
}

class ImagesFactory: ImagesFactoryProtocol {
    
    private let networkManager: ImagesLoadingProtocol
    
    init(networkManager: ImagesLoadingProtocol) {
        self.networkManager = networkManager
    }
    
    private var hitsData: [Hit]?
    private var items: [HitList] = []
    
    func loadData() {
        networkManager.loadImages { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let objects):
                    self.hitsData = objects.hits
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func requestImages() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var imageData = Data()
            hitsData.forEach { item in
                let preview = item.previewURL
                let previewURL = URL(string: preview)
                var imageData = Data()
                let data = HitList(id: item.id,
                                   pageURL: item.pageURL,
                                   previewWidth: item.previewWidth,
                                   previewHeight: item.previewHeight,
                                   imageURL: item.imageURL,
                                   imageWidth: item.imageWidth,
                                   imageHeight: item.imageHeight,
                                   imageSize: item.imageSize,
                                   views: item.views,
                                   user: item.user,
                                   userImageURL: item.userImageURL)
                self.items.append(data)
            }
        }
    }
}
