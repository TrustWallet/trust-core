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
        return Crypto.sha256(self.rawData.toData())
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
