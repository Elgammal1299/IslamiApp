plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.islamic.wartaqi.app"
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
        applicationId = "com.islamic.wartaqi.app"
        minSdk = flutter.minSdkVersion   
        targetSdk = flutter.targetSdkVersion 
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        create("release") {
            storeFile = file("wartaqi-new.jks")
            storePassword = "WartaqiNew#2026"
            keyAlias = "wartaqi_alias"
            keyPassword = "WartaqiNew#2026"
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
