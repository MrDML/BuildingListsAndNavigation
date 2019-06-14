//
//  MapView.swift
//  CreatingAndCombiningViews
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019 mac. All rights reserved.
//

import SwiftUI
import MapKit

// 这个是结构体，也可以写成class, 在结构体中不能修改其属性值，只能通过添加mutaing 关键词在方法上
/*
 如何将UIKit 与 SwiftUI 进行结合
    结构体需要继承UIViewRepresentable协议，并且实现下面两个方法
    contentView：建立的第一个视图就是父视图，就和window的view 一样
    其他的子视图必须添加到contentView 上
 */
struct MapView: UIViewRepresentable {
    

    // 初始化方法
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    // 当时图发生任何变化后的更新方法
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
    

}


struct MapView_Previews : PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

