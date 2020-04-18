//
//  DebuggerView.swift
//
//  Created by Claudio Madureira Silva Filho on 4/7/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

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
    
    let cellHTTPRequest = DebuggerHTTPRequestTableViewCell.self
    
    var cellHTTPRequestIdentifier: String {
        return String(describing: cellHTTPRequest)
    }
    
    private var items: [DebuggerItemViewModel] = []
    
    static var shared: DebuggerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpHiddablePointer()
        self.setUpSideMenuBackground()
        self.lblEnvironments.text = "Environment"
        self.collectionEnvironments.delegateAwlaysSelected = self
        let debugger = Debugger.shared
        self.collectionEnvironments.selectedIndex = debugger.indexSelectedEnvironment
        self.collectionEnvironments.items = debugger.environments
        self.lblLocalizations.text = "Localization"
        self.collectionLocalizations.delegateAwlaysSelected = self
        self.collectionLocalizations.selectedIndex = debugger.indexSelectedLocalization
        self.collectionLocalizations.items = debugger.localizations
        self.lblIdentifier.text = "Identifier"
        self.switchIdentifier.setOn(!Debugger.shared.labelTextIdentifierIsHidden, animated: false)
        self.setUpButtonToggles()
        self.setUpButtonExpand()
        self.lblVersion.text = "Main bundle at " + Bundle.main.readableVersion
        self.addDismissSideMenuTapGesture()
        self.addDismissSideMenuPanGesture()
        self.setSideMenu(hidden: true)
        self.items = debugger.mappedItems.reversed()
        self.setUpTableView()
        
        self.btnClear.onTouchUpInside { (btn) in
            let item0 = ExampleHTTPResquest(
                url: "https://test.api.com/some-image",
                method: "POST",
                statusCode: 200,
                headers: [:],
                body: Data(),
                responseBody: Data(),
                startDate: nil,
                duration: 3)
            Debugger.shared.debug(item0)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview == nil else { return }
        DebuggerView.shared = nil
    }
    
    public func appearInAnimated() {
        self.animateSideMenu(toHide: false, completion: nil)
    }
    
    public func animateSideMenu(toHide: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.setSideMenu(hidden: toHide)
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
    
    private func setUpHiddablePointer() {
        self.viewHiddablePointer.layer.masksToBounds = true
        self.viewHiddablePointer.layer.cornerRadius = 2.5
        self.viewHiddablePointer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func setUpTableView() {
        let nib = UINib(nibName: self.cellHTTPRequestIdentifier, bundle: Bundle(for: cellHTTPRequest))
        self.tableView.register(nib, forCellReuseIdentifier: self.cellHTTPRequestIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 250
        self.tableView.separatorColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
        self.tableView.backgroundColor = #colorLiteral(red: 0.147652775, green: 0.1476788819, blue: 0.1476462185, alpha: 1)
        self.tableView.layer.borderWidth = 1
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
    
    private func setUpButtonExpand() {
        self.btnClear.setTitle(nil, for: .normal)
        self.btnClear.setTitle(nil, for: .highlighted)
        let image = UIImage(named: "trash")?
            .resize(toWidth: 15)
            .tintPicto(.white)
        self.btnClear.setImage(image, for: .normal)
        self.btnClear.setImage(image, for: .highlighted)
        self.btnClear.onChangeState { (btn, state) in
            btn.alpha = state.alpha
        }
    }
    
    private func setUpSideMenuBackground() {
        self.viewSideMenu.backgroundColor = .clear
        
        // Adding corner and border below
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
        view.layer.borderWidth = 1
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
    
    private func setSideMenu(hidden: Bool) {
        self.setSideMeuHidden(progress: hidden ? 1 : 0)
    }
    
    private func setSideMeuHidden(progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else { return }
        let x: CGFloat = (UIScreen.main.bounds.size.width/2 + 30)*progress
        self.viewSideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
        self.viewHiddablePointer.transform = self.viewSideMenu.transform
        self.viewBackground.alpha = 1 - progress
    }
    
    @objc
    private func tapDismissSideMenuAction() {
        self.animateSideMenu(toHide: true) { [weak self] in
            self?.removeFromSuperview()
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
                        self?.removeFromSuperview()
                    }
                }
            } else {
                let toHide = speed > 100
                self.animateSideMenu(toHide: toHide) { [weak self] in
                    if toHide {
                        self?.removeFromSuperview()
                    }
                }
            }
            
        default:
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                let x: CGFloat = point.x < 0 ? 0 : point.x
                let progress: CGFloat = x/(UIScreen.main.bounds.width/2)
                self.viewSideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
                self.viewHiddablePointer.transform = self.viewSideMenu.transform
                self.viewBackground.alpha = 1 - progress
            }, completion: nil)
            
        }
    }
    
}


extension DebuggerView: AlwaysSelectedCollectionViewDelegate {
    
    func collection(collectionView: AlwaysSelectedCollectionView, didSelectItemAt index: Int) {
        let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
        generator.prepare()
        defer {
            generator.selectionChanged()
        }
        let debugger = Debugger.shared
        switch collectionView {
        case self.collectionEnvironments:
            Debugger.shared.indexSelectedEnvironment = index
            Debugger.shared.emit(event: .didChangeEnvironment(debugger.environments[index]))
        case self.collectionLocalizations:
            Debugger.shared.indexSelectedLocalization = index
            Debugger.shared.emit(event: .didChangeLocalization(debugger.localizations[index]))
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
            return cell
        }
        return .init()
    }
    
}
