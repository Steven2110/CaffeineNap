//
//  AvatarView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 02.05.2023.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: ImagePlaceHolder.avatar, size: 80)
    }
}
