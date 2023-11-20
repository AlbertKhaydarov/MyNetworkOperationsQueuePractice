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

protocol ImagesListFactoryDelegate: AnyObject {
    func didReceiveDataList(dataForList: [HitList])
    func didLoadDataForListFromServer()
    //    func didFailToLoadData(with error: Error)
}

class ImagesFactory: ImagesFactoryProtocol {
    
    private let networkManager: ImagesLoadingProtocol
    weak private var delegate: ImagesListFactoryDelegate?
    
    init(networkManager: ImagesLoadingProtocol, delegate: ImagesListFactoryDelegate) {
        self.networkManager = networkManager
        self.delegate = delegate
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
                    self.requestImages()
                 
//                    self.delegate?.didLoadDataForListFromServer()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
      print(hitsData)
    }
    
    func requestImages() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let hitsData = hitsData else {return}
            hitsData.forEach { item in
           
                guard let previewURL = URL(string: item.previewURL) else {return}
                
                let data = HitList(id: item.id,
                                   previewURL: previewURL
//                                   previewWidth: item.previewWidth,
//                                   previewHeight: item.previewHeight,
//                                   imageURL: item.largeImageURL,
//                                   imageWidth: item.imageWidth,
//                                   imageHeight: item.imageHeight,
//                                   imageSize: item.imageSize,
//                                   views: item.views,
//                                   user: item.user,
//                                   userImageURL: item.userImageURL
                )
                self.items.append(data)
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveDataList(dataForList: self.items)
            }
        }
    }
}
