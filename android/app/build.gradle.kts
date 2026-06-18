plugins {
    id("com.android.application")
    id("kotlin-android")
    id("org.jetbrains.kotlin.plugin.compose")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.islamic.wartaqi.app"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    buildFeatures {
        compose = true
    }



    dependencies {
        implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10")
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
        implementation("androidx.glance:glance-appwidget:1.1.0")
        implementation("androidx.glance:glance-material3:1.1.0")
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.islamic.wartaqi.app"
        minSdk = flutter.minSdkVersion   
        targetSdk = flutter.targetSdkVersion 
        versionCode = 6
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

configurations.all {
    resolutionStrategy {
        force("androidx.glance:glance-appwidget:1.1.1")
        force("androidx.glance:glance:1.1.1")
        force("androidx.glance:glance-material3:1.1.1")
        force("androidx.compose.remote:remote-creation-android:1.0.0-alpha07")
    }
}
