//
//  AddPhotosView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 30.06.25.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddPhotosView: View {
    @State private var isCameraPresented = false
    @State private var isPhotoPickerPresented = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Start adding pictures")
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                isCameraPresented = true
            }) {
                Text("Open Camera")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isCameraPresented) {
                ImagePicker(pickerFactory: { createPicker(sourceType: .camera) }, selectedImage: $selectedImage)
            }
            
            Button(action: {
                isPhotoPickerPresented = true
            }) {
                Text("Open Photo Library")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                ImagePicker(pickerFactory: { createPicker(sourceType: .photoLibrary) }, selectedImage: $selectedImage)
            }
        }
        .padding()
    }
    
    func createPicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        return picker
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var pickerFactory: () -> UIImagePickerController
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = pickerFactory()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
