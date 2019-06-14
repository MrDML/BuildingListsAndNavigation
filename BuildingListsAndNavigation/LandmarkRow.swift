//
//  LandmarkRow.swift
//  BuildingListsAndNavigation
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019 mac. All rights reserved.
//

import SwiftUI

struct LandmarkRow : View {
    
    var landmark:Landmark
    
    var body: some View {
        HStack() {
            landmark.image(forSize: 50)
            Text(landmark.name)
            Spacer()

        }
    }
}

// previewLayout 将当个布局独立屏幕出来
#if DEBUG
struct LandmarkRow_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
         .previewLayout(.fixed(width: 300, height: 70))
       
    }
}
#endif
