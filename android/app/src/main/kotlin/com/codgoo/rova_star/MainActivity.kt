package com.codgoo.rova_star

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.View
import io.flutter.embedding.android.FlutterFragmentActivity;

class MainActivity : FlutterFragmentActivity() {
	private val channelName = "com.codgoo.rova_star/ui"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"setImmersiveMode" -> {
						window.decorView.post {
							window.decorView.systemUiVisibility = (
								View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
									or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
									or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
									or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
								)
						}
						result.success(null)
					}
					else -> result.notImplemented()
				}
			}
	}
}
