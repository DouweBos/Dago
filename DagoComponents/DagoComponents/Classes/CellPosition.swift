//
//  CellPosition.swift
//  Dago
//
//  Created by Douwe Bos on 08/06/2022.
//

import Foundation

public struct CellPosition {
    public let row: Int?
    public let cell: Int?
    
    public init(row: Int?, cell: Int?) {
        self.row = row
        self.cell = cell
    }
    
    public func with(row: Int? = nil, cell: Int?) -> CellPosition {
        return CellPosition(
            row: row ?? self.row,
            cell: cell ?? self.cell
        )
    }
}

public protocol CellPositionBindable: AnyObject {
    var cellPosition: CellPosition? { get set }
    
    func bind(to position: CellPosition)
}

public extension CellPositionBindable {
    func bind(to position: CellPosition) {
        cellPosition = position
    }
}

public protocol IndexPathBindable: AnyObject {
    var indexPath: IndexPath? { get set }
    
    func bind(to indexPath: IndexPath)
}

public extension IndexPathBindable {
    func bind(to path: IndexPath) {
        indexPath = path
    }
}
