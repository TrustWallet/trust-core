// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension TronTransaction {
    public var hasSignature: Bool {
        return signature.count == 1
    }

    public mutating func addSignature(_ signature: Data) {
        self.signature.append(signature)
    }

    public func getSignature() -> Data {
        return self.signature[0]
    }

    public mutating func hash() -> Data {
        let rawDataHexString = "0a02b23822083b15cb7e4a1c816840e8a1c5bfdd2c520a54657374253230312e315a67080112630a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412320a1541469d067b0d0ab59ef5399cc9c9cf6ca2bc129a43121541699fefc95ac273a3b4188efc68fd4b26ca85ec5218e09143"
        let data = rawDataHexString.hexadecimal()!
        return Crypto.sha256(data)
    }

    public mutating func sign(privateKey: Data) -> Data {
        let signature = Crypto.sign(hash: self.hash(), privateKey: privateKey)
        self.addSignature(signature)
        return signature
    }
}

extension TronTransaction.RawData {
    public func toData() -> Data {
        var myself = self
        return Data(bytes: &myself, count: MemoryLayout.size(ofValue: self))
    }
}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    public func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }
}

extension Data {

    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.

    public func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
