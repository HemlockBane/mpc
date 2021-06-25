package com.teamapt.customers.moniepoint.lib

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import androidx.preference.PreferenceManager
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.annotation.RestrictTo
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG
import androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_WEAK
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import java.io.File
import java.io.IOException
import java.nio.charset.StandardCharsets
import java.security.*
import java.security.cert.CertificateException
import java.util.*
import java.util.concurrent.ThreadLocalRandom
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec

enum class AuthenticationType {
    SetUp, Login
}

class BiometricChannel constructor(
        private var mContext: Context,
        private val keyFileName: String,
        private val keyStoreName: String,
        private val keyAlias: String) {

    private var mActivity: FragmentActivity? = null

    @RequiresApi(Build.VERSION_CODES.M)
    fun startFingerPrintForMode(
            mActivity: FragmentActivity,
            authenticationMode: AuthenticationType = AuthenticationType.Login,
            canAuthenticateCallback: (can: Boolean) -> Unit = {},
            authenticationCallback: (fingerprintKey: String?, extraMessage: String?) -> Unit = { _, _ -> },
            authenticate: Boolean = false) {

        val isFingerPrintAvailable = isFingerPrintAuthAvailable()

        canAuthenticateCallback(isFingerPrintAvailable.first)

        this.mActivity = mActivity

        if (isFingerPrintAvailable.first && authenticate) {
            //let's check that we have the key generated
            //Attempt to create key
            createKey()
            //initialize the cipher for what we want to do
            val cipher = getCipher()
            try {
                if(!initializeCipher(cipher, authenticationMode)) {
                    authenticationCallback(null, "Failed to initialize cipher")
                    return
                }
                //use the cipher
                startUpBiometricPrompt(authenticationMode, cipher, authenticationCallback)
            } catch (ex: Exception) {
                ex.printStackTrace()
//                FirebaseCrashlytics.getInstance().recordException(ex)
//                Toast.makeText(mActivity, "Unable to initialize biometric for login", Toast.LENGTH_LONG).show()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun startUpBiometricPrompt(authMode: AuthenticationType, cipher: Cipher,
                                       authenticationCallback: (cryptoKey: String?,
                                                                extraMessage: String?) -> Unit) {
        val executor = ContextCompat.getMainExecutor(mContext)
        val prompt = BiometricPrompt(mActivity!!, executor, object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                super.onAuthenticationSucceeded(result)
                if (authMode == AuthenticationType.SetUp) {
                    val fingerprintKey = setupFingerPrintWithPassword(result)
                    authenticationCallback(fingerprintKey, null)
                } else if (authMode == AuthenticationType.Login) {
                    val fingerprintKey = getDecryptedFingerPrintPassword(result)
                    authenticationCallback(fingerprintKey, null)
                }
            }
            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                super.onAuthenticationError(errorCode, errString)
                authenticationCallback(null, "Failed Login")
            }

            override fun onAuthenticationFailed() {
                super.onAuthenticationFailed()
                authenticationCallback(null, "Failed Login")
            }
        })
        val promptInfo = BiometricPrompt.PromptInfo.Builder()
                .setTitle(if (authMode == AuthenticationType.Login) "Fingerprint Login" else "Register Fingerprint")
                .setSubtitle(if (authMode == AuthenticationType.Login) "Login to Moniepoint using fingerprint" else "Register to enable finger print login")
                .setAllowedAuthenticators(BIOMETRIC_STRONG)
                .setNegativeButtonText("Cancel")

        println("Starting up biometric")
        prompt.authenticate(promptInfo.build(), BiometricPrompt.CryptoObject(cipher))
    }

    fun isFingerPrintAuthAvailable() : Pair<Boolean, String?> {
        val biometricManager = BiometricManager.from(mContext)
        return when (biometricManager.canAuthenticate(BIOMETRIC_STRONG or BIOMETRIC_WEAK)) {
            BiometricManager.BIOMETRIC_SUCCESS -> Pair(true, "")
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> Pair(false, null)
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> Pair(false, null)
            BiometricManager.BIOMETRIC_ERROR_UNSUPPORTED -> {
                return Pair(false, "BIOMETRIC_ERROR_UNSUPPORTED: Not supported on this android version")
            }
            BiometricManager.BIOMETRIC_STATUS_UNKNOWN -> {
                Log.w(TAG, "Possible issues might occur with biometrics library on this device")
                return Pair(false, "Possible issues might occur with biometrics on this device")
            }
            BiometricManager.BIOMETRIC_ERROR_SECURITY_UPDATE_REQUIRED -> {
                return Pair(false, "A security vulnerability has been discovered with one or\n" +
                        "     * more hardware sensors. An update to your fingerprint is required")
            }
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                // Show a message that the user hasn't set up a fingerprint or lock screen.
                return Pair(false, """
                            Secure lock screen hasn't been set up.
                            Go to 'Settings -> Security -> FINGERPRINT' to set up a fingerprint
                            """.trimIndent())
            }
            else -> return Pair(false, null)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun createKey() {
        if (secretKeyExist()) return
        try {
            val keyBuilder = KeyGenParameterSpec
                    .Builder(keyAlias, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
                    .setUserAuthenticationRequired(true)
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                keyBuilder.setInvalidatedByBiometricEnrollment(true)
            }
            generateSecretKey(keyBuilder.build())
        } catch (ex: NoSuchAlgorithmException) {
            ex.printStackTrace()
            Log.e(TAG, "Failed to generate key: " + ex.message)
        }
    }

    private fun secretKeyExist(): Boolean {
        return PreferenceManager.getDefaultSharedPreferences(mContext).contains(FINGERPRINT_KEY_CREATED)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun generateSecretKey(keyGenParameterSpec: KeyGenParameterSpec) {
        val keyGenerator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, keyStoreName)
        keyGenerator.init(keyGenParameterSpec)
        keyGenerator.generateKey()
        PreferenceManager.getDefaultSharedPreferences(mContext)
                .edit().putBoolean(FINGERPRINT_KEY_CREATED, true).apply()
    }

    private fun getSecretKey(): SecretKey? {
        val keyStore = KeyStore.getInstance(keyStoreName)
        keyStore.load(null)
        return keyStore.getKey(keyAlias, null) as SecretKey?
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getCipher() : Cipher {
        return try{
            val transformation = "${KeyProperties.KEY_ALGORITHM_AES}/${KeyProperties.BLOCK_MODE_CBC}/${KeyProperties.ENCRYPTION_PADDING_PKCS7}"
            Cipher.getInstance(transformation)
        }
        catch (ex: NoSuchAlgorithmException){
            throw RuntimeException("Failed to get an instance of Cipher", ex)
        }catch (px: NoSuchPaddingException){
            throw RuntimeException("Failed to get an instance of Cipher", px)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun initializeCipher(cipher: Cipher, authType: AuthenticationType): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return false
        }
        return try {
            val key = getSecretKey()
            val ivParams: IvParameterSpec
            val iv: ByteArray
            if(authType == AuthenticationType.SetUp) {
                cipher.init(Cipher.ENCRYPT_MODE, key)
                ivParams = cipher.parameters.getParameterSpec(IvParameterSpec::class.java)
                iv = ivParams.iv
                val fos = mContext.openFileOutput(keyFileName, Context.MODE_PRIVATE)
                fos.write(iv)
                fos.close()
            } else if(authType == AuthenticationType.Login) {
                val file = File("${mContext.filesDir}/$keyFileName")
                val fileSize = file.length().toInt()
                iv  = ByteArray(fileSize)
                val fis = mContext.openFileInput(keyFileName)
                fis.read(iv, 0, fileSize)
                fis.close()
                ivParams = IvParameterSpec(iv)
                cipher.init(Cipher.DECRYPT_MODE, key, ivParams)
            }
            true
        }catch (@SuppressLint("NewApi", "LocalSuppress") ex: KeyPermanentlyInvalidatedException){
            false
        } catch (kex: KeyStoreException){
            throw RuntimeException("Failed to initialize Cipher", kex)
        } catch (cex: CertificateException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        } catch (cex: UnrecoverableKeyException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        } catch (cex: NoSuchAlgorithmException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        } catch (cex: InvalidKeyException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        } catch (cex: InvalidAlgorithmParameterException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        } catch (cex: IOException) {
            throw RuntimeException("Failed to initialize Cipher", cex)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setupFingerPrintWithPassword(result: BiometricPrompt.AuthenticationResult): String {
        val password = generateFingerprintPassword()
        val bytes = result.cryptoObject?.cipher?.doFinal(password?.toByteArray())
        val encodedPassword = Base64.encodeToString(bytes, Base64.NO_WRAP)
        saveEncryptedPassword(encodedPassword)
        return password!!
    }

    private fun getDecryptedFingerPrintPassword(result: BiometricPrompt.AuthenticationResult) : String {
        val savedPassword = getFingerprintPassword()
        return try {
            val bytes = Base64.decode(savedPassword, Base64.NO_WRAP)
            result.cryptoObject?.cipher?.doFinal(bytes)?.decodeToString()!!
        } catch (ex: IllegalBlockSizeException) {
            throw RuntimeException("Failed to decrypt password", ex)
        } catch (ex: BadPaddingException){
            throw RuntimeException("Failed to decrypt password", ex)
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Throws(NoSuchAlgorithmException::class)
    private fun generateFingerprintPassword(): String? {
        val deviceKey = UUID.randomUUID().toString()
        val timeInstance = Calendar.getInstance().timeInMillis.toString()
        val salt = ThreadLocalRandom.current().nextLong().toString()
        val passwordCollection = arrayOf(deviceKey, timeInstance, salt)
        val order = arrayOf(0, 1, 2)
        shuffleArray(order)
        val password = StringBuilder()
        for (anOrder in order) {
            password.append(passwordCollection[anOrder])
        }
        val digest = MessageDigest.getInstance("SHA-256")
        val hash = digest.digest(password.toString().toByteArray(StandardCharsets.UTF_8))
        return Base64.encodeToString(hash, Base64.NO_WRAP)
    }

    @RestrictTo(RestrictTo.Scope.LIBRARY)
    private fun saveEncryptedPassword(encryptedPassword: String?) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return
        }
        PreferenceManager.getDefaultSharedPreferences(mContext).edit()
                .putString(FINGERPRINT_PASSWORD_COMPAT, encryptedPassword)
                .apply()
    }

    fun deleteFingerprintPassword() {
        PreferenceManager.getDefaultSharedPreferences(mContext).edit()
                .remove(FINGERPRINT_PASSWORD_COMPAT).apply()
    }

    fun getFingerprintPassword(): String? {
        return PreferenceManager.getDefaultSharedPreferences(mContext)
                .getString(FINGERPRINT_PASSWORD_COMPAT, null)
    }

    companion object {
        private const val TAG = "BiometricHelper"
        private const val FINGERPRINT_KEY_CREATED = "fingerprintKeyCreated"
        private const val FINGERPRINT_PASSWORD_COMPAT = "fingerprintPasswordCompat"

        fun <T> shuffleArray(array: Array<T>?) {
            if (array == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                return
            }
            val rnd: Random = ThreadLocalRandom.current()
            for (i in array.size - 1 downTo 1) {
                val index = rnd.nextInt(i + 1)
                // Simple swap
                val temp = array[index]
                array[index] = array[i]
                array[i] = temp
            }
        }
    }
}