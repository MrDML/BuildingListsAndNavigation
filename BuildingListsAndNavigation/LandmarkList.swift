//
//  LandmarkList.swift
//  BuildingListsAndNavigation
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019 mac. All rights reserved.
//


import SwiftUI

struct LandmarkList: View {
    var body: some View {
        NavigationView {
            ListView()
        }
       
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .previewDevice(PreviewDevice(rawValue: "iPhone XS"))
       
    }
}

struct ListView : View {
    var body: some View {
        return List(landmarkData) { landmark in
            NavigationButton.init(destination: LandmarkDetail(landmark: landmark)){
                
                LandmarkRow(landmark: landmark)
            }
            
            }
            .navigationBarTitle(Text("Landmarks"),displayMode: .inline)
    }
}
