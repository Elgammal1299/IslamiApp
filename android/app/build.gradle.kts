plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.wartaqi.islamiapp"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true

    }
    dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wartaqi.islamiapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 3
        versionName = "1.0.2"
  
    }

    signingConfigs {
        create("release") {
            storeFile = file("islami-keystore.jks") // موجود في نفس المجلد
            storePassword = "Strong#1299"
            keyAlias = "islami"
            keyPassword = "Strong#1299"
        }
    }

    buildTypes {
          debug {
        }
       
release {
    // توقيع النسخة تم تعطيله مؤقتًا
    // signingConfig = signingConfigs.getByName("release")
    isMinifyEnabled = false
    isShrinkResources = false
    proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
}



    }

}

flutter {
    source = "../.."
}
