package brinnixs.transak


import android.content.Context
import android.graphics.Bitmap
import android.view.View
import android.app.Activity
import android.widget.FrameLayout
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.net.Uri
import android.os.Handler


import android.widget.ProgressBar
import android.view.KeyEvent
import android.webkit.WebViewClient
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.bottom_sheet_webview.view.*

import io.flutter.plugin.common.MethodChannel.Result


class BottomSheetWebView(
    arguments: HashMap<String, Any>,
    context: Context,
    private val result: Result,
) : FrameLayout(context) {

    private val mBottomSheetDialog: BottomSheetDialog = BottomSheetDialog(context)
    private var mCurrentWebViewScrollY = 0
    private val redirectURL: String = arguments["redirectURL"] as? String ?: ""
    private val transkURL: String = arguments["url"] as? String ?: ""
    private val parameters = mutableMapOf<String, String>()
    private val handler = Handler()
    private var isResultSent = false 



    init {
        inflateLayout(context)
        setupBottomSheetBehaviour()
        setupWebView()
        showWithUrl(transkURL)
        
    }

    private fun inflateLayout(context: Context) {
        inflate(context, R.layout.bottom_sheet_webview, this)
        mBottomSheetDialog.setContentView(this)
        mBottomSheetDialog.window?.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)
            ?.setBackgroundResource(android.R.color.transparent)
    }

    private fun setupBottomSheetBehaviour() {
        (parent as? View)?.let { view ->
            BottomSheetBehavior.from(view).let { behaviour ->
                behaviour.addBottomSheetCallback(object :
                    BottomSheetBehavior.BottomSheetCallback() {
                    override fun onSlide(bottomSheet: View, slideOffset: Float) {
            //              if (webView.canGoBack()) {
            //                    webView.goBack()
            // }
                    }

                    override fun onStateChanged(bottomSheet: View, newState: Int) {
                        if (newState == BottomSheetBehavior.STATE_DRAGGING && mCurrentWebViewScrollY > 0) {
                            behaviour.setState(BottomSheetBehavior.STATE_EXPANDED)
                        } else if (newState == BottomSheetBehavior.STATE_HIDDEN) {
                            handleTransactionCancelled()
                        }
                    }
                })
            }
        }
    }

    private fun setupWebView() {
        val progressBar: ProgressBar = findViewById(R.id.progressBar)
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                val url = request?.url
                val components = Uri.parse(url.toString())

                if (!isResultSent && components.host == Uri.parse(redirectURL).host) {
                    isResultSent = true
                    components.queryParameterNames.forEach { item ->
                        components.getQueryParameter(item)?.let { value ->
                            parameters[item] = value
                        }
                    }
                    TransakPlugin.sendEvent(parameters)
                    handler.postDelayed({
                        close()
                        result.success(parameters)
                    }, 5000)

                    return true
                }
                return false
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                progressBar.visibility = View.VISIBLE
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                progressBar.visibility = View.GONE
            }
        }

        webView.onScrollChangedCallback = object : ObservableWebView.OnScrollChangeListener {
            override fun onScrollChanged(l: Int, t: Int, oldl: Int, oldt: Int) {
                mCurrentWebViewScrollY = t
            }
        }

         webView.setOnKeyListener { _, keyCode, event ->
            if (keyCode == KeyEvent.KEYCODE_BACK && event.action == KeyEvent.ACTION_UP && webView.canGoBack()) {
                webView.goBack()
                true
            } else {
                false
            }
        }

     
    }

    private fun showWithUrl(url: String) {
        webView.settings.javaScriptEnabled = true
        webView.loadUrl(url)
        mBottomSheetDialog.show()
    }

    private fun close() {
        handler.removeCallbacksAndMessages(null)
        mBottomSheetDialog.dismiss()
        disposeWebView()
    }

     private fun handleTransactionCancelled() {
        if (!isResultSent) {
            isResultSent = true
            result.error("TRANSACTION_CANCELLED", "Transaction cancelled", null)
        }
        close()
    }

    private fun disposeWebView() {
        //TODO:dispose webview
        webView?.let {
        it.loadUrl("about:blank")
        it.onPause()
        it.removeAllViews()
        it.destroyDrawingCache()
        it.destroy()
    }
}
}
