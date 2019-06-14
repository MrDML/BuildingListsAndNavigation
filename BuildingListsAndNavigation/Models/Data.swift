/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

let landmarkData: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


/// 图片处理的类（将大图等比缩放至小图）
final class ImageStore {
    fileprivate typealias _ImageDictionary = [String: [Int: CGImage]]
    fileprivate var images: _ImageDictionary = [:]
    
    // 默认图片的尺寸，作为key
    fileprivate static var originalSize = 250
    // 图片的缩放比例
    fileprivate static var scale = 2
    
    // 单利对象
    static var shared = ImageStore()
    
    
    /// 根据name和指定的size 获取一个SwiftUI 的图片（缩放好的图片）
    /// - Parameter name: name description
    /// - Parameter size: size description
    func image(name: String, size: Int) -> Image {
        // 拿到原始图片的对组
        let index = _guaranteeInitialImage(name: name)
        
        // 获取指定size的图片
        // 如果在字典中获取不到，那么就进行等比压缩变换
        let sizedImage = images.values[index][size]
            ?? _sizeImage(images.values[index][ImageStore.originalSize]!, to: size * ImageStore.scale)
        
        images.values[index][size] = sizedImage
        
        return Image(sizedImage, scale: Length(ImageStore.scale), label: Text(verbatim: name))
    }
    
    
    /// 获取一个索引对组 [Int: CGImage] 对应的 index ，因为这个字典是双层字典结构，
    /// - Parameter name: 外层key
    fileprivate func _guaranteeInitialImage(name: String) -> _ImageDictionary.Index {
        
        // 判定字典中是否能够可以直接获取到值，如果没有，下面打代码直接存入值到字典中
        if let index = images.index(forKey: name) {
            return index
        }
        
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"), // 从Bundle 中加载图片
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        
        // 将获取的原始图片存入字典
        // ImageStore.originalSize 定义的图片尺寸默认值
        images[name] = [ImageStore.originalSize: image]
        // 返回索引类型对应的对组
        return images.index(forKey: name)!
    }
    
    
    /// 根据原始图片和指定的size 获取一个处理好的图
    /// - Parameter image: 原始图片
    /// - Parameter size: 指定的尺寸
    fileprivate func _sizeImage(_ image: CGImage, to size: Int) -> CGImage {
        
        
        guard
            let colorSpace = image.colorSpace, // 颜色通道
            // 获取图片的上下文
            let context = CGContext(
                data: nil,
                width: size, height: size,
                bitsPerComponent: image.bitsPerComponent, // 图片的通道
                bytesPerRow: image.bytesPerRow,            //
                space: colorSpace,
                bitmapInfo: image.bitmapInfo.rawValue) // 位图的信息
            else {
                fatalError("Couldn't create graphics context.")
        }
        // 设置图片的质量
        context.interpolationQuality = .high
        
        // 绘制图片
        context.draw(image, in: CGRect(x: 0, y: 0, width: size, height: size))
        
        // 从上下文中获取图片
        if let sizedImage = context.makeImage() {
            return sizedImage
        } else {
            fatalError("Couldn't resize image.")
        }
    }
}

