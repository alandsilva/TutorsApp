//
//  TutorDetailView.swift
//  Tutors
//
//  Created by Alan on 18.5.2021.
//

import SwiftUI

struct TutorDetailView: View {
    //MARK: - properties
    @ObservedObject var tutorVM: TutorViewModel
//    let tutor: Tutor
    
    //MARK: - body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // intro video
                Image(tutorVM.tutor.photoURL)
                    .resizable()
                    .scaledToFit()
                
                // headline
                HeadingView(headingImage: "info.circle", headingText: "Description")
                Text(tutorVM.tutor.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
                
                
            }//: vstack
            .navigationBarTitle(tutorVM.tutor.name)
            .navigationBarItems(trailing:
                                    HStack(spacing: 20) {
                                        Button(action: {}, label: {
                                            Image(systemName: "message")
                                        })
                                        Button(action: {}, label: {
                                            Image(systemName: "heart")
                                        })
                                    }
                                    .font(.title2)
            )
            
            
        }
    }
}

//struct TutorDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            TutorDetailView(tutor: Tutor.data[5])
//        }
//
//    }
//}