//
//  ImagesModels.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//

import Foundation

struct HitList: Codable {
    let id: Int
    let pageURL: String
    let previewWidth, previewHeight: Int
    let imageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let user: String
    let userImageURL: String
}

struct ImagesListViewModel {
    let pageURL: String
    let user: String
}
