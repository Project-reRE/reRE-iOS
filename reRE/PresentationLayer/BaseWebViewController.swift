//
//  BaseWebViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/14/24.
//

import UIKit
import WebKit
import Then
import SnapKit

final class BaseWebViewController: BaseNavigationViewController {
    var coordinator: CommonBaseCoordinator?
    
    private lazy var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
        $0.navigationDelegate = self
        $0.scrollView.showsVerticalScrollIndicator = false
    }
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init()
        
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openWebView()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubview(webView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        webView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    private func openWebView() {
        let urlRequest = URLRequest(url: url)
        
        DispatchMain.async { [weak self] in
            self?.webView.load(urlRequest)
        }
    }
}

// MARK: - WKNavigationDelegate
extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let _ = navigationAction.request.url {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
}
