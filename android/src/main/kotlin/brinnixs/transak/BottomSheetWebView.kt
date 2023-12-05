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
import android.view.ViewGroup
import android.view.LayoutInflater


import android.widget.ProgressBar
import android.view.KeyEvent
import android.webkit.WebViewClient
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
// import kotlinx.android.synthetic.main.bottom_sheet_webview.view.*
import brinnixs.transak.databinding.BottomSheetWebviewBinding


import io.flutter.plugin.common.MethodChannel.Result


class BottomSheetWebView(
    arguments: HashMap<String, Any>,
    context: Context,
    private val result: Result,
) : FrameLayout(context) {

    private val mBottomSheetDialog: BottomSheetDialog = BottomSheetDialog(context)
    private val binding: BottomSheetWebviewBinding = BottomSheetWebviewBinding.inflate(LayoutInflater.from(context), this, true)
    private var mCurrentWebViewScrollY = 0
    private val redirectURL: String = arguments["redirectURL"] as? String ?: ""
    private val transkURL: String = arguments["url"] as? String ?: ""
    private val parameters = mutableMapOf<String, String>()
    private val handler = Handler()
    private var isResultSent = false 



  init {
    if (binding.root.parent != null) {
        (binding.root.parent as ViewGroup).removeView(binding.root) // Remove from the current parent if exists
    }
    mBottomSheetDialog.setContentView(binding.root)
    setupBottomSheetBehaviour()
    setupWebView()
    showWithUrl(transkURL)
}

    private fun setupBottomSheetBehaviour() {
        (parent as? View)?.let { view ->
            BottomSheetBehavior.from(view).let { behaviour ->
                behaviour.addBottomSheetCallback(object :
                    BottomSheetBehavior.BottomSheetCallback() {
                    override fun onSlide(bottomSheet: View, slideOffset: Float) {
            //              if ( binding.webView.canGoBack()) {
            //                     binding.webView.goBack()
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
         val progressBar: ProgressBar = binding.progressBar

         binding.webView.settings.javaScriptEnabled = true
         binding.webView.webViewClient = object : WebViewClient() {
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

         binding.webView.onScrollChangedCallback = object : ObservableWebView.OnScrollChangeListener {
            override fun onScrollChanged(l: Int, t: Int, oldl: Int, oldt: Int) {
                mCurrentWebViewScrollY = t
            }
        }

          binding.webView.setOnKeyListener { _, keyCode, event ->
            if (keyCode == KeyEvent.KEYCODE_BACK && event.action == KeyEvent.ACTION_UP &&  binding.webView.canGoBack()) {
                 binding.webView.goBack()
                true
            } else {
                false
            }
        }

     
    }

    private fun showWithUrl(url: String) {
         binding.webView.settings.javaScriptEnabled = true
         binding.webView.loadUrl(url)
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
        binding.webView?.let {
        it.loadUrl("about:blank")
        it.onPause()
        it.destroyDrawingCache()
        it.destroy()
    }
}
}
