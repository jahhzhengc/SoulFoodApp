//
//  ImageCacheManager.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 18/9/24.
//

import Foundation
import UIKit
import SwiftUI

class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    private init() {}

    private var imageCache: [URL: UIImage] = [:]
    
    func getImage(for url: URL) -> UIImage? {
        return imageCache[url]
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        imageCache[url] = image
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // If the image is already cached, return early
        if imageCache[url] != nil {
            return
        }

        // Fetch image from URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil) // Failed to load image
                return
            }
            
            // Cache the image
            DispatchQueue.main.async {
                self.imageCache[url] = image
                completion(image)
            }
        }.resume()
    }
}

extension Image {
    // Helper function to convert SwiftUI Image to UIImage
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        let format = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }
    }
}
