package com.teamapt.moniepoint_flutter

import com.amplifyframework.auth.cognito.AWSCognitoAuthPlugin
import com.amplifyframework.core.Amplify
import com.amplifyframework.predictions.aws.AWSPredictionsPlugin
import io.flutter.app.FlutterApplication

class MoniepointApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        try {
            Amplify.addPlugin(AWSCognitoAuthPlugin())
            Amplify.addPlugin(AWSPredictionsPlugin())
            Amplify.configure(applicationContext)
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }
}