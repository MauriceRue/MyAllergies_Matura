//
//  ImageSaver.swift
//  MyAllergies_Matura
//
//  Created by Maurice Ruefenacht on 12.12.2023.
//
//  Code von Ale Patron https://github.com/apatronl


import Photos
import UIKit

class ImageSaver: NSObject, ObservableObject {

  @Published public var saveResult: ImageSaveResult?

  public func saveImage(_ image: UIImage) {
    let imageLabel = "My Allergies"
    let photoLibraryAuthStatus = PHPhotoLibrary.authorizationStatus()
    if photoLibraryAuthStatus == .authorized {
      saveImage(image, withLabel: imageLabel)
      return
    }

    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
      DispatchQueue.main.async {
        if status == .authorized {
          self.saveImage(image, withLabel: imageLabel)
          return
        }
        self.saveResult = ImageSaveResult(saveStatus: .libraryPermissionDenied)
      }
    }
  }

  private func saveImage(_ image: UIImage, withLabel label: String) {
    if let imageWithLabel = addLabel(label, toImage: image) {
      UIImageWriteToSavedPhotosAlbum(imageWithLabel, self, #selector(saveError), nil)
      return
    }

    UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
  }

  private func addLabel(_ label: String, toImage image: UIImage) -> UIImage? {
    let font = UIFont.boldSystemFont(ofSize: 24)
    let text: NSString = NSString(string: label)

    // Set text font and color
    let attr = [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.foregroundColor: UIColor.systemGray
    ]
    let textPadding: CGFloat = 8

    // Get size
    let sizeOfText = text.size(withAttributes: attr)
    let heightOffset = sizeOfText.height + textPadding * 2
    let width = image.size.width
    let height = image.size.height + heightOffset

    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)

    if let context = UIGraphicsGetCurrentContext() {
      UIColor.white.setFill()
      let rect = CGRect(x: 0, y: 0, width: width, height: height)
      context.fill(rect)
    }

    // Draw image
    image.draw(in: CGRect(x: 0, y: heightOffset, width: width, height: image.size.height))

    // Draw text
    text.draw(
      in: CGRect(
        x: (width / 2) - (sizeOfText.width / 2),
        y: textPadding,
        width: width,
        height: height),
      withAttributes: attr
    )

    // Get new image
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    
    return newImage
  }

  @objc private func saveError(
    _ image: UIImage,
    didFinishSavingWithError error: Error?,
    contextInfo: UnsafeRawPointer
  ) {
    if error != nil {
      saveResult = ImageSaveResult(saveStatus: .error)
    } else {
      saveResult = ImageSaveResult(saveStatus: .success)
    }
  }
}

struct ImageSaveResult: Identifiable {
  let id = UUID()
  let saveStatus: ImageSaveStatus
}

enum ImageSaveStatus {
  case success
  case error
  case libraryPermissionDenied
}

