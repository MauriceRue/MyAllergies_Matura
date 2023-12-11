//
//  QRCodeGenerator.swift
//  MyAllergies_Matura
//
//  Created by Maurice Ruefenacht on 12.12.2023.
//
//  Code von Ale Patron https://github.com/apatronl


import CoreImage.CIFilterBuiltins
import UIKit

struct QRCodeGenerator {

  private let context = CIContext()
  private let filter = CIFilter.qrCodeGenerator()

  public func generateQRCode(forUrlString urlString: String) -> QRCode? {
    guard !urlString.isEmpty else { return nil }

    let data = Data(urlString.utf8)
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("H", forKey: "inputCorrectionLevel")
      // das sorgt für eine höhere Sicherheit beim Scannen. Mehr vom QR-Code kann verunreinigt sein und er funktioniert trotzdem noch.

    let transform = CGAffineTransform(scaleX: 10, y: 10)

    if let outputImage = filter.outputImage?.transformed(by: transform) {
      if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        let qrCode = QRCode(urlString: urlString, uiImage: UIImage(cgImage: cgImage))
        return qrCode
      }
    }
    return nil
  }
}

struct QRCode {
  let urlString: String
  let uiImage: UIImage
}
