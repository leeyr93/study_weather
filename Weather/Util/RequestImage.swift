//
//  RequestImage.swift
//  Weather
//
//  Created by leeyr on 2021/05/05.
//

import UIKit

struct RequestImage {
    //MARK: - Properties
    private static let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image", qos: .background)
    private static let imageCache: NSCache<NSString, UIImage> = NSCache()

    ///이미지 로드
    static func imageLoad(url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = url, url != "" else { return completion(nil) }
        imageDispatchQueue.async {
            if let cachedImage = imageCache.object(forKey: url as NSString) {
                completion(cachedImage)
            } else {
                guard let data: Data = try? Data(contentsOf: URL(string: url)!) else {
                    return completion(nil)
                }
                let image = UIImage(data: data)!
                imageCache.setObject(image, forKey: url as NSString)
                completion(image)
            }
        }
    }
}
