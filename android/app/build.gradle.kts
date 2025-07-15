plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // Add the Google services Gradle plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.company.tutor_connect"          // Tu namespace
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"                      // Versión NDK requerida por Firebase

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.company.tutor_connect"
        minSdk = 23                                   // Mínimo SDK compatible con Firebase Auth
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Firmar con debug keys por ahora para facilitar pruebas
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // Firebase Analytics (ejemplo)
    implementation("com.google.firebase:firebase-analytics")

    // Agrega aquí otras dependencias Firebase que necesites
}

flutter {
    source = "../.."
}

// 👇 Necesario para Firebase (igual que en el proyecto que funciona)
apply(plugin = "com.google.gms.google-services")