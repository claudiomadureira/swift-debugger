//
//  DebugDetailView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/21/20.
//

import UIKit

class DebugDetailView: UIView, NibLoadable {

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var lblBottom: UILabel!
    
    var viewModel: DebugDetailViewModel? {
        didSet {
            self.textView.attributedText = self.viewModel?.getText()
            self.lblBottom.text = self.viewModel?.getBottomText()
            self.tableView.isHidden = !(self.viewModel?.getIsTableContent() ?? false)
            self.tableView.reloadData()
        }
    }
    
    private let cellTitle = DebugDetailTitleTableViewCell.self
    private let cellContent = DebugDetailContentTableViewCell.self
    
    private var cellIdentifierTitle: String {
        return String(describing: self.cellTitle)
    }
    
    private var cellIdentifierContent: String {
        return String(describing: self.cellContent)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.1453362242, green: 0.1453362242, blue: 0.1453362242, alpha: 1)
        self.textView.textColor = .white
        self.lblBottom.textColor = .white
        self.lblBottom.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        self.setUpTableView()
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 100
        
        // TitleCell
        let bundleTitle = Bundle(for: self.cellTitle)
        let nibTitle = UINib(nibName: self.cellIdentifierTitle, bundle: bundleTitle)
        self.tableView.register(nibTitle, forCellReuseIdentifier: self.cellIdentifierTitle)
        
        // ContentCell
        let bundleContent = Bundle(for: self.cellContent)
        let nibContent = UINib(nibName: self.cellIdentifierContent, bundle: bundleContent)
        self.tableView.register(nibContent, forCellReuseIdentifier: self.cellIdentifierContent)
    }
    
}

extension DebugDetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension DebugDetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let item = self.viewModel?.items[row] else { return .init() }
        if let titleItem = item as? DebugDetailTitleItemViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifierTitle, for: indexPath) as! DebugDetailTitleTableViewCell
            cell.viewModel = titleItem
            return cell
        }
        if let contentItem = item as? DebugDetailContentItemViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifierContent, for: indexPath) as! DebugDetailContentTableViewCell
            cell.viewModel = contentItem
            return cell
        }
        return .init()
    }
    
    
    
}
