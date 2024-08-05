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

enum WebViewType {
    case privacyPolicy
    case serviceAgreement
    case notice
    case faq
    case termsPolicy
    case openAPI
    
    var titleText: String {
        switch self {
        case .privacyPolicy:
            return "개인정보 처리방침 보기"
        case .serviceAgreement:
            return "서비스 이용약관 보기"
        case .notice:
            return "공지사항 보기"
        case .faq:
            return "자주 묻는 질문과 답변 보기"
        case .termsPolicy:
            return "운영 정책 보기"
        case .openAPI:
            return "사용한 오픈 API 보기"
        }
    }
    
    var urlString: String {
        switch self {
        case .privacyPolicy:
            return StaticValues.privacyPolicyUrlString
        case .serviceAgreement:
            return StaticValues.serviceAgreementUrlString
        case .notice:
            return StaticValues.noticeUrlString
        case .faq:
            return StaticValues.faqUrlString
        case .termsPolicy:
            return StaticValues.termsPolicyUrlString
        case .openAPI:
            return StaticValues.openAPIUrlString
        }
    }
}

final class BaseWebViewController: BaseNavigationViewController {
    var coordinator: CommonBaseCoordinator?
    
    private lazy var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
        $0.navigationDelegate = self
        $0.scrollView.showsVerticalScrollIndicator = false
    }
    
    private let webViewType: WebViewType
    
    init(webViewType: WebViewType) {
        self.webViewType = webViewType
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
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: webViewType.titleText)
    }
    
    private func openWebView() {
        guard let url = URL(string: webViewType.urlString) else { return }
        
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
