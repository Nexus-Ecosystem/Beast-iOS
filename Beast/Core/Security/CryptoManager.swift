import Foundation
import CommonCrypto

enum CryptoManager {
    private static let key = "1234567890123456"

    static func encryptString(_ value: String) -> String? {
        guard
            let data = value.data(using: .utf8),
            let keyData = key.data(using: .utf8)
        else {
            return nil
        }

        var encryptedData = Data(
            count: data.count + kCCBlockSizeAES128
        )

        let outputLength = encryptedData.count
        var encryptedLength: size_t = 0

        let status = encryptedData.withUnsafeMutableBytes { encryptedBytes in
            data.withUnsafeBytes { dataBytes in
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
                        data.count,
                        encryptedBytes.baseAddress,
                        outputLength,
                        &encryptedLength
                    )
                }
            }
        }

        guard status == kCCSuccess else {
            return nil
        }

        encryptedData.removeSubrange(
            encryptedLength..<encryptedData.count
        )

        return encryptedData.base64EncodedString()
    }

    static func decryptString(_ value: String) -> String? {
        guard
            let encryptedData = Data(
                base64Encoded: value,
                options: .ignoreUnknownCharacters
            ),
            let keyData = key.data(using: .utf8)
        else {
            return nil
        }

        var decryptedData = Data(
            count: encryptedData.count + kCCBlockSizeAES128
        )

        let outputLength = decryptedData.count
        var decryptedLength: size_t = 0

        let status = decryptedData.withUnsafeMutableBytes { decryptedBytes in
            encryptedData.withUnsafeBytes { encryptedBytes in
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
                        encryptedBytes.baseAddress,
                        encryptedData.count,
                        decryptedBytes.baseAddress,
                        outputLength,
                        &decryptedLength
                    )
                }
            }
        }

        guard status == kCCSuccess else {
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
