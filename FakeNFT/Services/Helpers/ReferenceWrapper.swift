//
//  ReferenceWrapper.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

final class ReferenceWrapper<Wrapped> {
    var wrappedValue: Wrapped

    init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
}
