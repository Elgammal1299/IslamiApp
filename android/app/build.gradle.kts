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
    compileSdk = 36
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
        applicationId = "com.wartaqi.islamiapp"
        minSdk = flutter.minSdkVersion   // ✅ صح
        targetSdk = flutter.targetSdkVersion // ✅ صح
        versionCode = 4
        versionName = "1.0.2"
    }

    signingConfigs {
        create("release") {
            storeFile = file("islami-keystore.jks")
            storePassword = "Strong#1299"
            keyAlias = "islami"
            keyPassword = "Strong#1299"
        }
    }

    buildTypes {
        debug {
            // أي إعدادات خاصة بالـ debug
        }

        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            ndk {
                debugSymbolLevel = "FULL"
            }
        }
    }
}

flutter {
    source = "../.."
}
