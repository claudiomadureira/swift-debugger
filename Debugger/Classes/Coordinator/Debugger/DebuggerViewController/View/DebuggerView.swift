//
//  DebuggerView.swift
//
//  Created by Claudio Madureira Silva Filho on 4/7/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

protocol DebuggerViewDelegate: class {
    func debugger(_ view: DebuggerView, didPressToDetailAt index: Int)
    func debugger(_ view: DebuggerView, didDismiss animated: Bool)
    func debugger(_ view: DebuggerView, didPressClearLog button: UIButton)
    func debugger(_ view: DebuggerView, didPressToggles button: UIButton)
}

class DebuggerView: UIView, NibLoadable {
    
    @IBOutlet private weak var viewBackground: UIView!
    @IBOutlet private weak var viewSideMenu: UIView!
    @IBOutlet private weak var lblEnvironments: UILabel!
    @IBOutlet private weak var collectionLocalizations: AlwaysSelectedCollectionView!
    @IBOutlet private weak var lblLocalizations: UILabel!
    @IBOutlet private weak var collectionEnvironments: AlwaysSelectedCollectionView!
    @IBOutlet private weak var lblIdentifier: UILabel!
    @IBOutlet private weak var switchIdentifier: UISwitch!
    @IBOutlet private weak var btnClear: Button!
    @IBOutlet private weak var lblVersion: UILabel!
    @IBOutlet private weak var viewHiddablePointer: UIView!
    @IBOutlet private weak var viewHiddableSideMenu: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var btnToggles: Button!
    
    weak var delegate: DebuggerViewDelegate?
    
    let cellHTTPRequest = DebuggerHTTPRequestTableViewCell.self
    let cellSimpleLog = DebuggerSimpleLogTableViewCell.self
    
    var cellSimpleLogIdentifier: String {
        return String(describing: self.cellSimpleLog)
    }
    
    var cellHTTPRequestIdentifier: String {
        return String(describing: self.cellHTTPRequest)
    }
    
    private var items: [DebuggerItemViewModel] = []
    
    static var shared: DebuggerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpHiddablePointer()
        self.setUpSideMenuBackground()
        self.lblEnvironments.text = "Environment"
        self.collectionEnvironments.delegateAwlaysSelected = self
        self.collectionEnvironments.selectedIndex = Debug.indexSelectedEnvironment
        self.collectionEnvironments.items = Debug.environments
        self.lblLocalizations.text = "Localization"
        self.collectionLocalizations.delegateAwlaysSelected = self
        self.collectionLocalizations.selectedIndex = Debug.indexSelectedLocalization
        self.collectionLocalizations.items = Debug.localizations
        self.lblIdentifier.text = "Identifier"
        self.switchIdentifier.setOn(!Debug.labelTextIdentifierIsHidden, animated: false)
        self.setUpButtonToggles()
        self.setUpButtonClear()
        self.lblVersion.text = Bundle.main.readableVersion
        self.addDismissSideMenuTapGesture()
        self.addDismissSideMenuPanGesture()
        self.items = Debug.mappedItems.reversed()
        self.setUpTableView()
        
    }
    
    func animateSideMenu(toHide: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.setSideMenuAndShadow(hidden: toHide)
            }, completion: { _ in
                completion?()
        })
    }
    
    func append(item: DebuggerItemViewModel, animated: Bool, completion: (() -> Void)?) {
        self.items.insert(item, at: 0)
        self.tableView.beginUpdates()
        let indexPath: IndexPath = [0, 0]
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
    }
    
    func setSideMenuAndShadow(hidden: Bool) {
        let progress: CGFloat = hidden ? 1 : 0
        self.setSideMeuHidden(progress: progress)
        self.setShadowBackgroundHidden(progress: progress)
    }
    
    func setSideMeuHidden(progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else { return }
        let x: CGFloat = (UIScreen.main.bounds.size.width/2 + 30)*progress
        self.viewSideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
        self.viewHiddablePointer.transform = self.viewSideMenu.transform
        self.viewHiddableSideMenu.transform = self.viewSideMenu.transform
        
    }
    
    private func addDismissSideMenuPanGesture() {
        let gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.viewSideMenu.addGestureRecognizer(gesture)
        let _gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.viewHiddableSideMenu.addGestureRecognizer(_gesture)
    }
    
    private func addDismissSideMenuTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapDismissSideMenuAction))
        self.viewBackground.addGestureRecognizer(gesture)
        let _gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapDismissSideMenuAction))
        self.viewHiddableSideMenu.addGestureRecognizer(_gesture)
    }
    
    private func setUpHiddablePointer() {
        self.viewHiddablePointer.layer.masksToBounds = true
        self.viewHiddablePointer.layer.cornerRadius = 2.5
        self.viewHiddablePointer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func setUpTableView() {
        
        // DebuggerHTTPRequesTableViewtCell
        let bundleHTTPRequest = Bundle(for: self.cellHTTPRequest)
        let nibHTTPRequest = UINib(nibName: self.cellHTTPRequestIdentifier, bundle: bundleHTTPRequest)
        self.tableView.register(nibHTTPRequest, forCellReuseIdentifier: self.cellHTTPRequestIdentifier)
        
        // DebuggerSimpleLogTableViewCell
        let bundleSimpleLog = Bundle(for: self.cellSimpleLog)
        let nibSimpleLog = UINib(nibName: self.cellSimpleLogIdentifier, bundle: bundleSimpleLog)
        self.tableView.register(nibSimpleLog, forCellReuseIdentifier: self.cellSimpleLogIdentifier)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 250
        self.tableView.separatorColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
        self.tableView.backgroundColor = #colorLiteral(red: 0.147652775, green: 0.1476788819, blue: 0.1476462185, alpha: 1)
        self.tableView.layer.borderWidth = DebuggerViewConstants.borderWidth
        self.tableView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
    }
    
    private func setUpButtonToggles() {
        self.btnToggles.setTitle("Toggles", for: .normal)
        let titleColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.btnToggles.setTitleColor(titleColor, for: .normal)
        self.btnToggles.setTitleColor(titleColor, for: .highlighted)
        self.btnToggles.onChangeState { (btn, state) in
            btn.alpha = state.alpha
        }
        self.btnToggles.onTouchUpInside  { [weak self] (btn) in
            guard let self = self else { return }
            self.delegate?.debugger(self, didPressToggles: btn)
        }
    }
    
    private func setUpButtonClear() {
        self.btnClear.setTitle(nil, for: .normal)
        self.btnClear.setTitle(nil, for: .highlighted)
        let image = UIImage(named: "trash", in: Bundle.local, compatibleWith: nil)?
            .resize(toWidth: 15)
            .tintPicto(.white)
        self.btnClear.setImage(image, for: .normal)
        self.btnClear.setImage(image, for: .highlighted)
        self.btnClear.onChangeState { (btn, state) in
            btn.alpha = state.alpha
        }
        self.btnClear.onTouchUpInside { [weak self] (btn) in
            guard let self = self else { return }
            self.delegate?.debugger(self, didPressClearLog: btn)
        }
    }
    
    private func setUpSideMenuBackground() {
        self.viewSideMenu.backgroundColor = .clear
        
        // Adding corner and border below
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
        view.layer.borderWidth = DebuggerViewConstants.borderWidth
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        self.viewSideMenu.insertSubview(view, at: 0)
        self.viewSideMenu.addConstraints([
            view.topAnchor.constraint(equalTo: self.viewSideMenu.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.viewSideMenu.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.viewSideMenu.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.viewSideMenu.trailingAnchor, constant: 30)])
    }
    
    private func setShadowBackgroundHidden(progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else { return }
        self.viewBackground.alpha = 1 - progress
    }
    
    private func didPressToDetailAt(row: Int) {
        let invertedRow = self.items.count - 1 - row // The view displays the log upsidedown.
        self.delegate?.debugger(self, didPressToDetailAt: invertedRow)
    }
    
    @objc
    private func tapDismissSideMenuAction() {
        self.animateSideMenu(toHide: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.debugger(self, didDismiss: true)
        }
    }
    
    @objc
    private func panGesturePanned(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view?.superview)
        
        switch gesture.state {
        case .cancelled, .failed:
            self.animateSideMenu(toHide: false, completion: nil)
        case .began:
            break
        case .ended:
            let speed = gesture.velocity(in: gesture.view).x
            if speed == 100 {
                let translatedX = self.viewSideMenu.transform.tx
                let toHide = translatedX > UIScreen.main.bounds.width/4
                self.animateSideMenu(toHide: toHide) { [weak self] in
                    if toHide {
                        guard let self = self else { return }
                        self.delegate?.debugger(self, didDismiss: true)
                    }
                }
            } else {
                let toHide = speed > 100
                self.animateSideMenu(toHide: toHide) { [weak self] in
                    if toHide {
                        guard let self = self else { return }
                        self.delegate?.debugger(self, didDismiss: true)
                    }
                }
            }
            
        default:
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                let x: CGFloat = point.x < 0 ? 0 : point.x
                let progress: CGFloat = x/(UIScreen.main.bounds.width/2)
                self.viewSideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
                self.viewHiddablePointer.transform = self.viewSideMenu.transform
                self.viewHiddableSideMenu.transform = self.viewSideMenu.transform
                self.viewBackground.alpha = 1 - progress
            }, completion: nil)
            
        }
    }
    
}


extension DebuggerView: AlwaysSelectedCollectionViewDelegate {
    
    func collection(collectionView: AlwaysSelectedCollectionView, didSelectItemAt index: Int) {
        switch collectionView {
        case self.collectionEnvironments:
            Debug.indexSelectedEnvironment = index
            Debug.emit(event: .didChangeEnvironment(Debug.environments[index]))
        case self.collectionLocalizations:
            Debug.indexSelectedLocalization = index
            Debug.emit(event: .didChangeLocalization(Debug.localizations[index]))
        default:
            break
        }
    }
    
}


extension DebuggerView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension DebuggerView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = self.items[row]
        if let item = item as? DebuggerHTTPRequestCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellHTTPRequestIdentifier, for: indexPath) as! DebuggerHTTPRequestTableViewCell
            cell.viewModel = item
            cell.onTouchUpInside { [weak self] in
                self?.didPressToDetailAt(row: row)
            }
            return cell
        }
        if let item = item as? DebuggerSimpleLogViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellSimpleLogIdentifier, for: indexPath) as! DebuggerSimpleLogTableViewCell
            cell.viewModel = item
            cell.onTouchUpInside { [weak self] in
                self?.didPressToDetailAt(row: row)
            }
            return cell
        }
        return .init()
    }
    
}
