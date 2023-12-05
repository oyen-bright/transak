import Flutter
import UIKit
import WebKit


import Flutter
import UIKit
import WebKit

public class TransakPlugin: NSObject, FlutterPlugin {
    private static var eventChannel: FlutterEventChannel?
     static let eventStreamHandler = EventStreamHandler()

   
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "brinnixs/transak", binaryMessenger: registrar.messenger())
        eventChannel = FlutterEventChannel(name: "brinnixs/transak/events", binaryMessenger: registrar.messenger())

        let instance = TransakPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel?.setStreamHandler(eventStreamHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "initiateTransaction" || call.method == "initiateTransactionStream" {
            if let args = call.arguments as? Dictionary<String, Any?> {
                self.initiateTransaction(arguments: args, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments for initiating transaction are invalid or missing.", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func initiateTransaction(arguments: Dictionary<String, Any?>, result: @escaping FlutterResult) {
        guard let urlString = arguments["url"] as? String,
              let title = arguments["title"] as? String,
              let redirectURL = arguments["redirectURL"] as? String,
              let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        let webViewController = WebViewController(url: url, title: title, result: result, redirectURL: redirectURL)

        if let flutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            let navVC = UINavigationController(rootViewController: webViewController)
            flutterViewController.present(navVC, animated: true, completion: nil)
        } else {
            result(FlutterError(code: "UNABLE_TO_GET_ROOT_VIEW_CONTROLLER", message: "Unable to get root view controller", details: nil))
        }
    }
}

class EventStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendEvent(_ event: Any) {
        DispatchQueue.main.async {
            if let sink = self.eventSink {
                sink(event)
            } else {
                // print("Error: EventSink is nil")
            }
        }
    }

    static var shared: EventStreamHandler {
        return TransakPlugin.eventStreamHandler
    }
}

// WebViewController implementation continues...


class WebViewController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    private let webView: WKWebView = {
//        let configuration = WKWebViewConfiguration()
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//        configuration.defaultWebpagePreferences = preferences
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let url: URL
    private let redirectURL: String
    private let result: FlutterResult
    private var parameters: [String: String] = [:]



    init(url: URL, title: String, result: @escaping FlutterResult, redirectURL:String) {
        self.url = url
        self.result = result
        self.redirectURL = redirectURL
        super.init(nibName: nil, bundle: nil)
        self.title = title

 
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))

        configureButtons()
        setupProgressView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
          if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
              if webView.canGoBack {
                  webView.goBack()
                  return false 
              }
          }
          return true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        updateProgressViewFrame()
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))]
          navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(didTapReload)
        )
    }
    
    private func setupProgressView() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
        
        progressView.progressTintColor = view.tintColor
        progressView.trackTintColor = .clear
    }
    
    private func updateProgressViewFrame() {
        progressView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: 2.0)
    }
    
    
    @objc private func didTapDone() {
        guard isBeingPresented || presentingViewController != nil else { return }
        dismiss(animated: true) {
            self.result(FlutterError(code: "TRANSACTION_CANCELLED", message: "Transaction cancelled by user.", details: nil))
        }
    }
      @objc private func didTapReload() {
        webView.reload()
    }
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.1, animated: true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.setProgress(0.5, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
            self.progressView.setProgress(0, animated: false)
        }
    }
       func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
        if components.url?.absoluteURL.host ==  URL(string:self.redirectURL)?.absoluteURL.host {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    if let value = item.value {
                        parameters[item.name] = value
                    }
                }
            }

        EventStreamHandler.shared.sendEvent(self.parameters)

             DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if self.isBeingPresented || self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: {
                        self.result(self.parameters)
                    })
                } 
            }

            decisionHandler(.cancel)
            return
            }
        }

        decisionHandler(.allow)
    }


    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}
