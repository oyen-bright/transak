// import Flutter
// import UIKit
// import WebKit


// class WebViewController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
//     private let webView: WKWebView = {
// //        let configuration = WKWebViewConfiguration()
// //        let preferences = WKWebpagePreferences()
// //        preferences.allowsContentJavaScript = true
// //        configuration.defaultWebpagePreferences = preferences
        
//         let preferences = WKPreferences()
//         preferences.javaScriptEnabled = true
//         let configuration = WKWebViewConfiguration()
//         configuration.preferences = preferences

        
//         let webView = WKWebView(frame: .zero, configuration: configuration)
//         return webView
//     }()
    
//     private var progressView: UIProgressView = {
//         let progressView = UIProgressView(progressViewStyle: .bar)
//         progressView.translatesAutoresizingMaskIntoConstraints = false
//         return progressView
//     }()
    
//     private let url: URL
//     private let redirectURL: String
//     private let result: FlutterResult
//     private var parameters: [String: String] = [:]



//     init(url: URL, title: String, result: @escaping FlutterResult, redirectURL:String) {
//         self.url = url
//         self.result = result
//         self.redirectURL = redirectURL
//         super.init(nibName: nil, bundle: nil)
//         self.title = title
 
//     }

//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }
    
//     override func viewDidLoad() {
//         super.viewDidLoad()
//         view.addSubview(webView)
//         view.addSubview(progressView)
//         webView.navigationDelegate = self
//         webView.load(URLRequest(url: url))
//         configureButtons()
//         setupProgressView()
//         navigationController?.interactivePopGestureRecognizer?.delegate = self
//         navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//     }

//     func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//           if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
//               // Check if the web view can go back
//               if webView.canGoBack {
//                   // If yes, go back in the web view
//                   webView.goBack()
//                   return false // Prevent default swipe-back behavior
//               }
//           }
//           return true
//     }
    
    
//     override func viewDidLayoutSubviews() {
//         super.viewDidLayoutSubviews()
//         webView.frame = view.bounds
//         updateProgressViewFrame()
//     }
    
//     private func configureButtons() {
//         navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))]
//     }
    
//     private func setupProgressView() {
//         NSLayoutConstraint.activate([
//             progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//             progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//             progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//             progressView.heightAnchor.constraint(equalToConstant: 2.0)
//         ])
        
//         progressView.progressTintColor = view.tintColor
//         progressView.trackTintColor = .clear
//     }
    
//     private func updateProgressViewFrame() {
//         progressView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: 2.0)
//     }
    
//     @objc private func didTapDone() {
//         dismiss(animated: true){
//           self.result(FlutterError(code: "TRANSACTION_CANCELLED", message: "Transaction cancelled", details: nil))

//         }
//     }
    
    
//     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//         progressView.isHidden = false
//         progressView.setProgress(0.1, animated: true)
//     }
    
//     func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//         progressView.setProgress(0.5, animated: true)
//     }
    
//     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//         progressView.setProgress(1.0, animated: true)
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//             self.progressView.isHidden = true
//             self.progressView.setProgress(0, animated: false)
//         }
//     }
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if let url = navigationAction.request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
//                if components.host == self.redirectURL {
//                    if let queryItems = components.queryItems {
//                        for item in queryItems {
//                            if let value = item.value {
//                                parameters[item.name] = value
//                            }
//                        }
//                    }
                   
//                    dismiss(animated: true, completion: {
//                        print("Extracted Parameters: \(self.parameters)")
//                    })
                   
//                    decisionHandler(.cancel)
//                    return
//                }
//            }
           
//            decisionHandler(.allow)
//        }

//     func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//         progressView.isHidden = true
//         progressView.setProgress(0, animated: false)
//     }
// }
