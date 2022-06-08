//
//  Optional+Also.swift
//  DagoTracked
//
//  Created by Douwe Bos on 21/10/20.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

// MARK: - Dago Collection Section
open class DagoCollectionSection: SectionModelType {
    public typealias Item = DagoCollectionViewItem
    
    public let title: String
    public let items: [Item]
    
    required public init(
        original: DagoCollectionSection,
        items: [Item]
    ) {
        self.title = original.title
        self.items = items
    }
}

open class DagoTableSection: SectionModelType {
    public typealias Item = DagoTableViewItem
    
    public let title: String
    public let items: [Item]
    
    required public init(
        original: DagoTableSection,
        items: [Item]
    ) {
        self.title = original.title
        self.items = items
    }
}

// MARK: - Dago Collection View Cell
public protocol DagoCollectionViewCell: UICollectionViewCell {
    static var identifier: String { get }
    
    static func register(in collectionView: UICollectionView)
    
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> DagoCollectionViewCell
}

public extension DagoCollectionViewCell {
    static var identifier: String {
        get {
            return "\(type(of: self))"
        }
    }
    
    static func register(in collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: identifier)
    }
    
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

// MARK: - Dago Table View Cell
public protocol DagoTableViewCell: UITableViewCell {
    static var identifier: String { get }
    
    static func register(in tableView: UITableView)
    
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> DagoTableViewCell
}

public extension DagoTableViewCell {
    static var identifier: String {
        get {
            return "\(type(of: self))"
        }
    }
    
    static func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }
    
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

// MARK: - Dago Collection View Items
public protocol DagoCollectionViewItem {
    var identifier: String { get }
    
    static var cell: DagoCollectionViewCell.Type { get }
    
    func bind(cell: DagoCollectionViewCell)
    
    func compared(to: DagoCollectionViewItem) -> Bool
}

public extension DagoCollectionViewItem {
    var identifier: String {
        get {
            return Self.cell.identifier
        }
    }
    
    func compared(to: DagoCollectionViewItem) -> Bool {
        return false
    }
}

// MARK: - Dago Table View Items
public protocol DagoTableViewItem {
    var identifier: String { get }
    
    static var cell: DagoTableViewCell.Type { get }
    
    func bind(cell: DagoTableViewCell)
    
    func compared(to: DagoTableViewItem) -> Bool
}

public extension DagoTableViewItem {
    var identifier: String {
        get {
            return Self.cell.identifier
        }
    }
    
    func compared(to: DagoTableViewItem) -> Bool {
        return false
    }
}

public protocol DagoTableViewDataSourceHolder {
    var tableDataSource: DagoTableDataSource { get set }
}

public protocol DagoCollectionViewDataSourceHolder {
    var collectionDataSource: DagoCollectionDataSource { get set }
}

public extension DagoCollectionViewDataSourceHolder where Self: CellPositionBindable {
    func bind(to position: CellPosition) {
        cellPosition = position
        
        collectionDataSource.bind(to: position)
    }
}

public typealias DagoCollectionDataSourceOverload = ((CollectionViewSectionedDataSource<DagoCollectionSection>, UICollectionView, IndexPath) -> UICollectionViewCell?)

public typealias DagoCollectionDataSourceConfigureSupplementaryView = ((CollectionViewSectionedDataSource<DagoCollectionSection>, UICollectionView, String, IndexPath) -> UICollectionReusableView)

public typealias DagoTableDataSourceOverload = ((TableViewSectionedDataSource<DagoTableSection>, UITableView, IndexPath) -> UITableViewCell?)

public typealias DagoOverloadCellPosition = ((CellPosition?, IndexPath) -> CellPosition)

// MARK: - Dago Collection Data Source
open class DagoCollectionDataSource: CellPositionBindable {
    public struct Config {
        public let overloadCell: DagoCollectionDataSourceOverload?
        public let overloadCellPosition: DagoOverloadCellPosition?
        public let configureSupplementaryView: DagoCollectionDataSourceConfigureSupplementaryView?
        
        public init(
            overloadCell: DagoCollectionDataSourceOverload?,
            overloadCellPosition: DagoOverloadCellPosition?,
            configureSupplementaryView: DagoCollectionDataSourceConfigureSupplementaryView?
        ) {
            self.overloadCell = overloadCell
            self.overloadCellPosition = overloadCellPosition
            self.configureSupplementaryView = configureSupplementaryView
        }
    }
    
    public var cellPosition: CellPosition?
    
    public weak var collectionView: UICollectionView?
    public let config: Config
    
    public init(
        collectionView: UICollectionView,
        config: Config
    ) {
        self.collectionView = collectionView
        self.config = config
    }
    
    public func register(cell: DagoCollectionViewCell.Type) {
        if let collectionView = collectionView {
            cell.register(in: collectionView)
        } else {
            assertionFailure("[DagoCollectionDataSource] CollectionView is nil.")
        }
    }
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<DagoCollectionSection> {
        return RxCollectionViewSectionedReloadDataSource<DagoCollectionSection>(
            configureCell: { (dataSource, collectionView, index, _) -> UICollectionViewCell in
                let cellPosition: CellPosition = self.config.overloadCellPosition?(self.cellPosition, index)
                ?? CellPosition(row: self.cellPosition?.row, cell: self.cellCount(before: index.section) + index.row)
                
                let bindPosition: ((UICollectionViewCell) -> Swift.Void) = { cell in
                    if let cellPositionBindable = (cell as? CellPositionBindable) {
                        cellPositionBindable.bind(to: cellPosition)
                    }
                }
                
                let bindIndexPath: ((UICollectionViewCell) -> Swift.Void) = { cell in
                    if let indexPathBindable = (cell as? IndexPathBindable) {
                        indexPathBindable.bind(to: index)
                    }
                }
                
                if let overloadCell = self.config.overloadCell?(dataSource, collectionView, index) {
                    bindPosition(overloadCell)
                    bindIndexPath(overloadCell)
                    
                    return overloadCell
                }
                
                let item = dataSource[index]
                let cell = type(of: item).cell.dequeue(from: collectionView, for: index)
                bindPosition(cell)
                bindIndexPath(cell)
                item.bind(cell: cell)
                
                return cell
            },
            configureSupplementaryView: self.config.configureSupplementaryView
        )
    }
    
    private func cellCount(before section: Int) -> Int {
        guard let collectionView = collectionView,
              section > 0
        else { return 0 }
        
        return (0..<section).map { collectionView.numberOfItems(inSection: $0) }.reduce(0, +)
    }
}

// MARK: - Dago Table Data Source
open class DagoTableDataSource {
    public struct Config {
        public let overloadCell: DagoTableDataSourceOverload?
        public let overloadCellPosition: DagoOverloadCellPosition?
        
        public init(
            overloadCell: DagoTableDataSourceOverload?,
            overloadCellPosition: DagoOverloadCellPosition?
        ) {
            self.overloadCell = overloadCell
            self.overloadCellPosition = overloadCellPosition
        }
    }
    
    public var cellPosition: CellPosition?
    
    public weak var tableView: UITableView?
    public let config: Config
    
    public init(
        tableView: UITableView,
        config: Config
    ) {
        self.tableView = tableView
        self.config = config
    }
    
    public func register(cell: DagoTableViewCell.Type) {
        if let tableView = tableView {
            cell.register(in: tableView)
        } else {
            assertionFailure("[DagoTableDataSource] CollectionView is nil.")
        }
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<DagoTableSection> {
        return RxTableViewSectionedReloadDataSource<DagoTableSection>(
            configureCell: { (dataSource, tableView, index, _) -> UITableViewCell in
                let cellPosition: CellPosition = self.config.overloadCellPosition?(self.cellPosition, index)
                ?? CellPosition(row: self.cellPosition?.row, cell: self.cellCount(before: index.section) + index.row)
                
                let bindPosition: ((UITableViewCell) -> Swift.Void) = { cell in
                    if let cellPositionBindable = (cell as? CellPositionBindable) {
                        cellPositionBindable.bind(to: cellPosition)
                    }
                }
                
                let bindIndexPath: ((UITableViewCell) -> Swift.Void) = { cell in
                    if let indexPathBindable = (cell as? IndexPathBindable) {
                        indexPathBindable.bind(to: index)
                    }
                }
                
                if let overloadCell = self.config.overloadCell?(dataSource, tableView, index) {
                    bindPosition(overloadCell)
                    bindIndexPath(overloadCell)
                    
                    return overloadCell
                }
                
                let item = dataSource[index]
                let cell = type(of: item).cell.dequeue(from: tableView, for: index)
                bindPosition(cell)
                bindIndexPath(cell)
                item.bind(cell: cell)
                
                return cell
            }
        )
    }
    
    private func cellCount(before section: Int) -> Int {
        guard let tableView = tableView,
              section > 0
        else { return 0 }
        
        return (0..<section).map { tableView.numberOfRows(inSection: $0) }.reduce(0, +)
    }
}

// MARK: - Dago Collection View
open class DagoCollectionView: UICollectionView {
    public var collectionDataSource: DagoCollectionDataSource!
    
    public init(
        dataSource: DagoCollectionDataSource? = nil,
        config: DagoCollectionDataSource.Config = DagoCollectionDataSource.Config(
            overloadCell: nil,
            overloadCellPosition: nil,
            configureSupplementaryView: nil
        ),
        frame: CGRect,
        collectionViewLayout: UICollectionViewLayout
    ) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        
        self.collectionDataSource = dataSource ?? DagoCollectionDataSource(collectionView: self, config: config)
    }
    
    public required init?(coder: NSCoder) {
        return nil
    }
    
    public func register(cell: DagoCollectionViewCell.Type) {
        collectionDataSource.register(cell: cell)
    }
}

// MARK: - Dago Table View
open class DagoTableView: UITableView {
    public var tableDataSource: DagoTableDataSource!
    
    public init(
        tableDataSource: DagoTableDataSource? = nil,
        config: DagoTableDataSource.Config = DagoTableDataSource.Config(
            overloadCell: nil,
            overloadCellPosition: nil
        ),
        frame: CGRect,
        style: UITableView.Style = .plain
    ) {
        super.init(frame: frame, style: style)
        
        self.tableDataSource = tableDataSource ?? DagoTableDataSource(tableView: self, config: config)
    }
    
    public required init?(coder: NSCoder) {
        return nil
    }
    
    public func register(cell: DagoTableViewCell.Type) {
        tableDataSource.register(cell: cell)
    }
}
