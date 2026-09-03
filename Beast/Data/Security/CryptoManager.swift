import Foundation
import CommonCrypto

enum CryptoManager {
    private static let key = "1234567890123456"

    static func encrypt(_ data: String) -> String? {
        guard
            let dataToEncrypt = data.data(using: .utf8),
            let keyData = key.data(using: .utf8)
        else {
            return nil
        }

        let outputBufferSize =
            dataToEncrypt.count + kCCBlockSizeAES128

        var encryptedData = Data(
            count: outputBufferSize
        )

        var encryptedLength: size_t = 0

        let status = encryptedData.withUnsafeMutableBytes { encryptedBytes in
            dataToEncrypt.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(
                            kCCOptionPKCS7Padding |
                            kCCOptionECBMode
                        ),
                        keyBytes.baseAddress,
                        kCCKeySizeAES128,
                        nil,
                        dataBytes.baseAddress,
                        dataToEncrypt.count,
                        encryptedBytes.baseAddress,
                        outputBufferSize,
                        &encryptedLength
                    )
                }
            }
        }

        guard status == kCCSuccess else {
            print(
                "❌ CryptoManager encrypt error: \(status)"
            )
            return nil
        }

        encryptedData.removeSubrange(
            encryptedLength..<encryptedData.count
        )

        return encryptedData.base64EncodedString()
    }

    static func decrypt(
        _ encryptedData: String
    ) -> String? {
        guard
            let encryptedBytes = Data(
                base64Encoded: encryptedData
            ),
            let keyData = key.data(using: .utf8)
        else {
            return nil
        }

        let outputBufferSize =
            encryptedBytes.count + kCCBlockSizeAES128

        var decryptedData = Data(
            count: outputBufferSize
        )

        var decryptedLength: size_t = 0

        let status = decryptedData.withUnsafeMutableBytes { decryptedBytes in
            encryptedBytes.withUnsafeBytes { encryptedDataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(
                            kCCOptionPKCS7Padding |
                            kCCOptionECBMode
                        ),
                        keyBytes.baseAddress,
                        kCCKeySizeAES128,
                        nil,
                        encryptedDataBytes.baseAddress,
                        encryptedBytes.count,
                        decryptedBytes.baseAddress,
                        outputBufferSize,
                        &decryptedLength
                    )
                }
            }
        }

        guard status == kCCSuccess else {
            print(
                "❌ CryptoManager decrypt error: \(status)"
            )
            return nil
        }

        decryptedData.removeSubrange(
            decryptedLength..<decryptedData.count
        )

        return String(
            data: decryptedData,
            encoding: .utf8
        )
    }
}
