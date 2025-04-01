//
//  LikeButton.swift
//  Physiotherapy
//
//  Created by Priya Dube on 08/07/23.
//

import SwiftUI

import SwiftUI

struct LikeButton: View {
    @Binding var likeButtonPressed: Bool
    
    var body: some View {
        Button {
            likeButtonPressed.toggle()
        } label: {
            Image(systemName: likeButtonPressed ? "heart.fill" : "heart")
                .foregroundColor(Color("614D8F"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(likeButtonPressed: .constant(true))
    }
}
