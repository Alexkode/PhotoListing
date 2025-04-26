# Guide de Déploiement - PhotoListing

Ce document présente les procédures et configurations nécessaires pour déployer l'application PhotoListing dans différents environnements.

## 1. Vue d'ensemble

### 1.1 Architecture de déploiement

L'application PhotoListing est composée de plusieurs composants qui doivent être déployés:

```
┌───────────────────┐      ┌───────────────────┐      ┌───────────────────┐
│  Application      │      │  Backend AWS      │      │  OpenAI API       │
│  Mobile           │◄────►│  Serverless       │◄────►│  (Service Externe)│
│  (iOS/Android)    │      │  (Lambda/S3/etc)  │      │                   │
└───────────────────┘      └───────────────────┘      └───────────────────┘
```

### 1.2 Environnements

| Environnement | Description | Utilisation |
|---------------|-------------|-------------|
| **Développement** | Configuration avec logs verbeux, accès aux outils de debug | Développement actif |
| **Test** | Environnement similaire à la production pour tests | QA, tests d'intégration |
| **Production** | Environnement optimisé et sécurisé | Utilisateurs finaux |

### 1.3 Prérequis

- Compte AWS avec droits administratifs
- Compte OpenAI avec API key
- Apple Developer Program (pour iOS)
- Compte Google Play Developer (pour Android)
- Flutter SDK 3.10+ installé
- AWS CLI configuré
- Terraform 1.4+ (pour l'infrastructure as code)

## 2. Infrastructure Backend (AWS)

### 2.1 Ressources requises

| Service AWS | Usage | Configuration |
|-------------|-------|---------------|
| **Lambda** | Traitement des images, gestion OpenAI | 1GB RAM, timeout 30s |
| **API Gateway** | API RESTful | Throttling, authentification |
| **S3** | Stockage des images, statiques | Lifecycle rules, CORS |
| **Cognito** | Authentification | Pool utilisateurs, OAuth |
| **CloudFront** | CDN pour images | Cache optimisé |
| **DynamoDB** | Données transactionnelles | Table utilisateurs, projets |
| **SQS** | File de traitement | Délai de visibilité de 5 min |
| **CloudWatch** | Monitoring | Alarmes, logs |

### 2.2 Déploiement via Terraform

```hcl
# Extrait du fichier main.tf
provider "aws" {
  region = var.aws_region
}

module "lambda_function" {
  source = "./modules/lambda"
  
  function_name = "${var.environment}-photolisting-processor"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  memory_size   = 1024
  timeout       = 30
  
  environment_variables = {
    OPENAI_API_KEY     = var.openai_api_key
    STORAGE_BUCKET     = module.s3_bucket.bucket_name
    ENVIRONMENT        = var.environment
    LOG_LEVEL          = var.environment == "production" ? "INFO" : "DEBUG"
  }
  
  tags = {
    Environment = var.environment
    Application = "PhotoListing"
  }
}

module "api_gateway" {
  source = "./modules/api_gateway"
  
  name        = "${var.environment}-photolisting-api"
  lambda_arn  = module.lambda_function.function_arn
  stage_name  = var.environment
  
  cors_configuration = {
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE"]
    allow_headers     = ["Content-Type", "Authorization"]
    allow_credentials = true
  }
}

# [...autres ressources...]
```

### 2.3 Déploiement manuel (alternatives)

1. **Création des buckets S3**:
   ```bash
   aws s3 mb s3://photolisting-${ENV}-images
   aws s3 mb s3://photolisting-${ENV}-processing
   
   # Configurer CORS pour le bucket d'images
   aws s3api put-bucket-cors --bucket photolisting-${ENV}-images \
     --cors-configuration file://cors-config.json
   ```

2. **Déploiement des fonctions Lambda**:
   ```bash
   cd backend/lambda
   npm install
   npm run build
   
   zip -r function.zip dist node_modules
   
   aws lambda create-function \
     --function-name photolisting-${ENV}-processor \
     --runtime nodejs16.x \
     --handler dist/index.handler \
     --role arn:aws:iam::${ACCOUNT_ID}:role/photolisting-lambda-role \
     --zip-file fileb://function.zip \
     --environment "Variables={OPENAI_API_KEY=${OPENAI_KEY},STORAGE_BUCKET=photolisting-${ENV}-images}"
   ```

### 2.4 Mise à jour des fonctions Lambda

```bash
#!/bin/bash
# update-lambda.sh
ENV=$1
FUNCTION_NAME="photolisting-${ENV}-processor"

cd backend/lambda
npm install
npm run build
zip -r function.zip dist node_modules

aws lambda update-function-code \
  --function-name $FUNCTION_NAME \
  --zip-file fileb://function.zip
```

## 3. Application Mobile (Flutter)

### 3.1 Configuration de l'environnement

Créer un fichier `.env` pour chaque environnement:

```
# .env.development
API_BASE_URL=https://api-dev.photolisting.com
STORAGE_URL=https://storage-dev.photolisting.com
LOG_LEVEL=DEBUG

# .env.production
API_BASE_URL=https://api.photolisting.com
STORAGE_URL=https://storage.photolisting.com
LOG_LEVEL=INFO
```

Configuration dans Flutter via le package `flutter_dotenv`:

```dart
// lib/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get storageUrl => dotenv.env['STORAGE_URL'] ?? '';
  static bool get isProduction => dotenv.env['ENV'] == 'production';
  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'INFO';
  
  // Autres configurations...
}
```

### 3.2 Build Android

#### 3.2.1 Préparation de l'application

```bash
# Générer la clé de signature si pas déjà fait
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload -storepass PASSWORD -keypass PASSWORD

# Configurer la clé dans android/key.properties
echo "storePassword=PASSWORD" > android/key.properties
echo "keyPassword=PASSWORD" >> android/key.properties
echo "keyAlias=upload" >> android/key.properties
echo "storeFile=upload-keystore.jks" >> android/key.properties
```

Configurer le build dans `android/app/build.gradle`:

```gradle
// ... existing code ...

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        
        debug {
            applicationIdSuffix ".debug"
            versionNameSuffix "-debug"
        }
        
        staging {
            initWith release
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            matchingFallbacks = ['release']
        }
    }
    
    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "PhotoListing Dev"
        }
        
        production {
            dimension "environment"
            resValue "string", "app_name", "PhotoListing"
        }
    }
}
```

#### 3.2.2 Build pour différents environnements

```bash
# Environnement de développement
flutter build apk --flavor development --debug

# Environnement de test/staging
flutter build apk --flavor development --profile

# Environnement de production
flutter build appbundle --flavor production --release
```

#### 3.2.3 Déploiement sur Google Play

1. Accéder à Google Play Console
2. Créer une nouvelle release dans la piste appropriée (interne, alpha, bêta, production)
3. Téléverser le bundle AAB généré
4. Remplir les métadonnées de la release
5. Soumettre pour examen

### 3.3 Build iOS

#### 3.3.1 Préparation de l'application

```bash
# Configurer les environnements
cd ios
bundle exec fastlane match development
bundle exec fastlane match appstore
```

Configurer les schémas dans XCode:
1. Ouvrir `ios/Runner.xcworkspace`
2. Créer des configurations de build pour Development, Staging et Production
3. Créer les schémas correspondants

#### 3.3.2 Configurer Fastlane (recommandé)

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    build_app(
      scheme: "Runner",
      configuration: "Release-production",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: {
          "com.example.photolisting" => "match AppStore com.example.photolisting"
        }
      }
    )
    upload_to_testflight
  end
  
  desc "Build and upload to App Store"
  lane :release do
    build_app(
      scheme: "Runner",
      configuration: "Release-production",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: {
          "com.example.photolisting" => "match AppStore com.example.photolisting"
        }
      }
    )
    upload_to_app_store(
      skip_metadata: false,
      skip_screenshots: false
    )
  end
end
```

#### 3.3.3 Build pour différents environnements

```bash
# Via Flutter CLI
flutter build ios --flavor development --debug
flutter build ios --flavor development --profile
flutter build ios --flavor production --release

# Via Fastlane
cd ios
bundle exec fastlane beta
bundle exec fastlane release
```

#### 3.3.4 Déploiement sur App Store

1. Utiliser Fastlane comme défini ci-dessus, ou:
2. Ouvrir XCode, archiver l'application
3. Valider et téléverser vers App Store Connect
4. Configurer les métadonnées dans App Store Connect
5. Soumettre pour examen

## 4. Gestion des environnements

### 4.1 Variables d'environnement et secrets

#### 4.1.1 Stockage des secrets

Utiliser AWS Secrets Manager pour les secrets de production:

```bash
# Stocker la clé API OpenAI
aws secretsmanager create-secret \
  --name "/photolisting/${ENV}/openai-api-key" \
  --secret-string "${OPENAI_KEY}"
```

Configurer l'accès depuis Lambda:

```javascript
// backend/lambda/src/services/openai.js
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

async function getOpenAIKey() {
  const secretName = `/photolisting/${process.env.ENVIRONMENT}/openai-api-key`;
  const data = await secretsManager.getSecretValue({ SecretId: secretName }).promise();
  return JSON.parse(data.SecretString);
}

// ...
```

#### 4.1.2 Rotation des secrets

Configurer une rotation automatique des secrets:

```bash
# Configurer une rotation automatique pour la clé OpenAI
aws secretsmanager rotate-secret \
  --secret-id "/photolisting/${ENV}/openai-api-key" \
  --rotation-lambda-arn "arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:secret-rotation" \
  --rotation-rules "{\"AutomaticallyAfterDays\": 90}"
```

### 4.2 Gestion des URLs et endpoints

Configurer les domaines personnalisés:

```bash
# Créer un certificat SSL
aws acm request-certificate \
  --domain-name api.photolisting.com \
  --validation-method DNS \
  --subject-alternative-names "*.photolisting.com"

# Configurer un domaine personnalisé dans API Gateway
aws apigateway create-domain-name \
  --domain-name api.photolisting.com \
  --certificate-arn $CERTIFICATE_ARN \
  --endpoint-configuration types=EDGE

# Mapper le domaine à l'API
aws apigateway create-base-path-mapping \
  --domain-name api.photolisting.com \
  --rest-api-id $API_ID \
  --stage $STAGE
```

## 5. Stratégies de déploiement

### 5.1 Déploiement continu (CD)

#### 5.1.1 Pipeline CI/CD avec GitHub Actions

`.github/workflows/deploy.yml`:

```yaml
name: Deploy PhotoListing

on:
  push:
    branches: [ main, develop ]
    tags: [ 'v*' ]

jobs:
  deploy_backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
      
      - name: Set environment
        id: env
        run: |
          if [[ $GITHUB_REF == refs/tags/v* ]]; then
            echo "::set-output name=env::production"
          elif [[ $GITHUB_REF == refs/heads/main ]]; then
            echo "::set-output name=env::staging"
          else
            echo "::set-output name=env::development"
          fi
      
      - name: Deploy infrastructure
        run: |
          cd terraform
          terraform init
          terraform workspace select ${{ steps.env.outputs.env }} || terraform workspace new ${{ steps.env.outputs.env }}
          terraform apply -auto-approve -var="environment=${{ steps.env.outputs.env }}" -var="openai_api_key=${{ secrets.OPENAI_API_KEY }}"
  
  build_mobile:
    needs: deploy_backend
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.x'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Set environment
        id: env
        run: |
          if [[ $GITHUB_REF == refs/tags/v* ]]; then
            echo "::set-output name=env::production"
            echo "::set-output name=build_type::appbundle"
          elif [[ $GITHUB_REF == refs/heads/main ]]; then
            echo "::set-output name=env::staging"
            echo "::set-output name=build_type::apk"
          else
            echo "::set-output name=env::development"
            echo "::set-output name=build_type::apk"
          fi
      
      - name: Create .env file
        run: |
          cp .env.${{ steps.env.outputs.env }} .env
      
      - name: Build Android
        run: |
          flutter build ${{ steps.env.outputs.build_type }} --flavor ${{ steps.env.outputs.env }} --release
      
      # iOS build steps would be added here
```

### 5.2 Stratégie bleu/vert (production)

Pour minimiser les temps d'arrêt en production:

```bash
#!/bin/bash
# blue-green-deploy.sh

# Création de la nouvelle stack (green)
aws cloudformation create-stack \
  --stack-name photolisting-green \
  --template-body file://cloudformation/main.yaml \
  --parameters ParameterKey=Environment,ParameterValue=production

# Attente de la création complète
aws cloudformation wait stack-create-complete \
  --stack-name photolisting-green

# Tests de la nouvelle stack
echo "Exécution des tests de validation..."
./run-validation-tests.sh green

# Si les tests passent, mise à jour du DNS pour basculer le trafic
if [ $? -eq 0 ]; then
  aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch file://dns-update.json
  
  echo "Basculement terminé avec succès"
  
  # Suppression de l'ancienne stack (blue) après un délai
  sleep 600  # Attendre 10 minutes
  aws cloudformation delete-stack --stack-name photolisting-blue
else
  echo "Les tests ont échoué, annulation du déploiement"
  aws cloudformation delete-stack --stack-name photolisting-green
fi
```

### 5.3 Rollback et gestion des incidents

Procédure de rollback en cas de problème:

```bash
#!/bin/bash
# rollback.sh
ENV=$1

# Restaurer la version précédente du backend
aws lambda update-function-code \
  --function-name photolisting-${ENV}-processor \
  --s3-bucket photolisting-deployment \
  --s3-key lambda-backups/processor-${PREVIOUS_VERSION}.zip

# Retourner à la version précédente de l'API Gateway
aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name $ENV \
  --description "Rollback to version ${PREVIOUS_VERSION}"

echo "Rollback effectué vers la version ${PREVIOUS_VERSION}"
```

## 6. Configuration des applications

### 6.1 Configuration du endpoint OpenAI dans l'application

```dart
// lib/services/openai_service.dart
import 'package:dio/dio.dart';
import 'package:photolisting/config/app_config.dart';

class OpenAIService {
  final Dio _dio = Dio();
  
  Future<Map<String, dynamic>> enhanceImage(
    String imagePath,
    Map<String, dynamic> enhancementSettings,
  ) async {
    // Dans l'application mobile, nous passons par notre backend
    // qui gère la clé API OpenAI de manière sécurisée
    final response = await _dio.post(
      '${AppConfig.apiBaseUrl}/api/enhance',
      data: {
        'image_path': imagePath,
        'settings': enhancementSettings,
      },
    );
    
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to enhance image: ${response.statusCode}');
    }
  }
}
```

### 6.2 Configuration du backend

```javascript
// backend/lambda/src/config.js
const environments = {
  development: {
    openaiModel: 'dall-e-3',
    imageQuality: 'standard',
    maxImageSize: 4096,
    logLevel: 'debug',
    rateLimits: {
      requestsPerMinute: 10,
      tokensPerDay: 100000,
    },
  },
  staging: {
    openaiModel: 'dall-e-3',
    imageQuality: 'standard',
    maxImageSize: 4096,
    logLevel: 'info',
    rateLimits: {
      requestsPerMinute: 20,
      tokensPerDay: 200000,
    },
  },
  production: {
    openaiModel: 'dall-e-3',
    imageQuality: 'hd',
    maxImageSize: 4096,
    logLevel: 'warn',
    rateLimits: {
      requestsPerMinute: 50,
      tokensPerDay: 500000,
    },
  },
};

module.exports = environments[process.env.ENVIRONMENT || 'development'];
```

## 7. Monitoring et observabilité

### 7.1 Journalisation

Configuration de CloudWatch Logs:

```javascript
// backend/lambda/src/utils/logger.js
const winston = require('winston');
const { createLogger, format, transports } = winston;

const logger = createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: format.combine(
    format.timestamp(),
    format.json()
  ),
  defaultMeta: { service: 'photolisting-api' },
  transports: [
    new transports.Console()
  ]
});

module.exports = logger;
```

### 7.2 Métriques et alertes

Exemple de métriques CloudWatch:

```bash
# Créer une alarme pour les erreurs API
aws cloudwatch put-metric-alarm \
  --alarm-name "ApiGateway5xxErrors" \
  --alarm-description "Alarm when API Gateway returns 5xx errors" \
  --metric-name "5XXError" \
  --namespace "AWS/ApiGateway" \
  --dimensions "Name=ApiName,Value=photolisting-api" "Name=Stage,Value=production" \
  --statistic "Sum" \
  --period 60 \
  --threshold 5 \
  --comparison-operator "GreaterThanOrEqualToThreshold" \
  --evaluation-periods 1 \
  --alarm-actions $SNS_TOPIC_ARN
```

### 7.3 Surveillance de la santé de l'application

Endpoint de health check:

```javascript
// backend/lambda/src/handlers/health.js
exports.handler = async (event) => {
  try {
    // Vérifier la connexion à la base de données
    await testDatabaseConnection();
    
    // Vérifier les quotas OpenAI
    const quotaStatus = await checkOpenAIQuota();
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        status: 'healthy',
        version: process.env.VERSION || 'unknown',
        quotaStatus,
        timestamp: new Date().toISOString()
      })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        status: 'unhealthy',
        error: error.message,
        timestamp: new Date().toISOString()
      })
    };
  }
};
```

Configurer des tests de disponibilité:

```bash
# Configurer un contrôle de santé CloudWatch
aws cloudwatch put-metric-alarm \
  --alarm-name "HealthCheckFailure" \
  --alarm-description "Alarm when the health check fails" \
  --metric-name "HealthCheckStatus" \
  --namespace "PhotoListing" \
  --statistic "Minimum" \
  --period 60 \
  --threshold 1 \
  --comparison-operator "LessThanThreshold" \
  --evaluation-periods 2 \
  --alarm-actions $SNS_TOPIC_ARN
```

## 8. Sécurité

### 8.1 Chiffrement et protection des données

Configurer le chiffrement S3:

```bash
# Activer le chiffrement par défaut sur les buckets S3
aws s3api put-bucket-encryption \
  --bucket photolisting-${ENV}-images \
  --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

### 8.2 IAM et contrôle d'accès

Politique IAM pour la fonction Lambda:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::photolisting-${ENV}-images/*",
        "arn:aws:s3:::photolisting-${ENV}-processing/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:/photolisting/${ENV}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${REGION}:${ACCOUNT_ID}:log-group:/aws/lambda/photolisting-${ENV}*:*"
    }
  ]
}
```

### 8.3 Sécurité de l'application mobile

Configuration de la sécurité dans Flutter:

```dart
// lib/utils/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();
  
  static Future<void> saveApiToken(String token) async {
    await _storage.write(key: 'api_token', value: token);
  }
  
  static Future<String?> getApiToken() async {
    return await _storage.read(key: 'api_token');
  }
  
  static Future<void> deleteApiToken() async {
    await _storage.delete(key: 'api_token');
  }
}
```

## 9. Sauvegarde et récupération

### 9.1 Stratégie de sauvegarde

```bash
# Configurer la réplication entre régions pour les buckets S3
aws s3api put-bucket-replication \
  --bucket photolisting-production-images \
  --replication-configuration file://replication-config.json
```

Contenu de `replication-config.json`:

```json
{
  "Role": "arn:aws:iam::${ACCOUNT_ID}:role/s3-replication-role",
  "Rules": [
    {
      "Status": "Enabled",
      "Priority": 1,
      "DeleteMarkerReplication": { "Status": "Enabled" },
      "Destination": {
        "Bucket": "arn:aws:s3:::photolisting-production-images-backup",
        "StorageClass": "STANDARD"
      }
    }
  ]
}
```

### 9.2 Procédure de reprise d'activité

Documentation du plan de reprise:

1. **Scénario de panne de région AWS:**
   ```bash
   # Rediriger le trafic vers la région de secours
   aws route53 change-resource-record-sets \
     --hosted-zone-id $HOSTED_ZONE_ID \
     --change-batch file://dr-dns-update.json
   
   # Promouvoir la réplique de base de données
   aws dynamodb update-table \
     --table-name photolisting-users \
     --global-table-update '{"ReplicationGroupUpdate": {"RegionName": "us-west-2", "ReplicaStatus": "ACTIVE"}}'
   ```

2. **Restauration de données:**
   ```bash
   # Restaurer des images à partir de la sauvegarde
   aws s3 sync s3://photolisting-production-images-backup/ s3://photolisting-production-images/
   ```

## 10. Déploiement spécifique par plateforme

### 10.1 Configuration Firebase

1. Créer un projet Firebase
2. Ajouter les applications Android et iOS
3. Télécharger et ajouter les fichiers de configuration:
   - Android: `google-services.json` dans `android/app/`
   - iOS: `GoogleService-Info.plist` dans `ios/Runner/`

Intégration dans Flutter:

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.4.0
  firebase_analytics: ^10.0.7
  firebase_crashlytics: ^3.0.7
  firebase_messaging: ^14.1.4
```

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');
  
  // Initialiser Firebase
  await Firebase.initializeApp();
  
  // Configurer Crashlytics
  if (AppConfig.isProduction) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  
  runApp(MyApp());
}
```

### 10.2 Configuration des notifications push

```dart
// lib/services/push_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // Demander les permissions (iOS)
    NotificationSettings settings = await _fcm.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Obtenir le token
      String? token = await _fcm.getToken();
      
      // Enregistrer le token sur le serveur
      await _registerTokenWithBackend(token);
      
      // Configurer les gestionnaires de notification
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      
      // Vérifier les notifications initiales
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleInitialMessage(initialMessage);
      }
    }
  }
  
  // Implémentation des gestionnaires...
}
```

### 10.3 Intégration des services de paiement

Pour Google Play Billing:

```gradle
// android/app/build.gradle
dependencies {
    // ... autres dépendances
    implementation 'com.android.billingclient:billing:5.0.0'
}
```

```dart
// lib/services/in_app_purchase_service.dart
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  Future<void> initialize() async {
    // Écouter les mises à jour des achats
    final purchaseUpdatedSubscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: _onPurchaseDone,
      onError: _onPurchaseError,
    );
    
    // Vérifier si les achats sont disponibles
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      // Les achats ne sont pas disponibles
      return;
    }
    
    // Charger les produits disponibles
    const Set<String> _kIds = {'premium_monthly', 'premium_yearly'};
    final ProductDetailsResponse response = 
        await _inAppPurchase.queryProductDetails(_kIds);
    
    if (response.notFoundIDs.isNotEmpty) {
      // Gérer les produits non trouvés
    }
    
    List<ProductDetails> products = response.productDetails;
    // Stocker les produits pour utilisation ultérieure
  }
  
  // Implémentation des méthodes d'achat...
}
```

## Annexes

### A. Liste de vérification de déploiement

```
## Prédéploiement
- [ ] Tests automatisés passent
- [ ] Revue de code effectuée
- [ ] Configurations d'environnement vérifiées
- [ ] Variables d'environnement et secrets configurés

## Déploiement Backend
- [ ] Infrastructure Terraform appliquée
- [ ] Fonctions Lambda déployées
- [ ] API Gateway configurée
- [ ] Buckets S3 configurés
- [ ] Bases de données provisionnées
- [ ] Tests de santé de l'API réussis

## Déploiement Mobile
- [ ] Builds iOS générés
- [ ] Builds Android générés
- [ ] Tests de connexion à l'API réussis
- [ ] Vérification des configurations de notification
- [ ] Vérification des intégrations de paiement

## Post-déploiement
- [ ] Vérification des métriques et logs
- [ ] Confirmation du fonctionnement des alertes
- [ ] Tests de bout en bout
- [ ] Vérification des performances
- [ ] Documentation mise à jour
```

### B. Scripts utilitaires

#### build-deploy.sh
```bash
#!/bin/bash
# Script pour construire et déployer l'application

# Paramètres
ENV=$1
VERSION=$2

if [[ -z "$ENV" || -z "$VERSION" ]]; then
  echo "Usage: $0 <environment> <version>"
  echo "Example: $0 production 1.2.0"
  exit 1
fi

# Déployer le backend
echo "Deploying backend to $ENV..."
cd terraform
terraform workspace select $ENV || terraform workspace new $ENV
terraform apply -auto-approve -var="environment=$ENV" -var="version=$VERSION"
cd ..

# Construire l'application mobile
echo "Building mobile app version $VERSION for $ENV..."
cp .env.$ENV .env

# Android
flutter build appbundle --flavor $ENV --release

# iOS
cd ios
bundle exec fastlane $ENV version:$VERSION
cd ..

echo "Deployment complete!"
```

#### monitor-deployment.sh
```bash
#!/bin/bash
# Script pour surveiller le déploiement

ENV=$1

if [[ -z "$ENV" ]]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

# Surveiller les logs Lambda
echo "Monitoring Lambda logs..."
aws logs tail /aws/lambda/photolisting-$ENV-processor --follow

# Dans une autre fenêtre, surveiller les métriques
echo "API Gateway requests:"
aws cloudwatch get-metric-statistics \
  --metric-name "Count" \
  --namespace "AWS/ApiGateway" \
  --dimensions "Name=ApiName,Value=photolisting-api" "Name=Stage,Value=$ENV" \
  --start-time $(date -u -v-1H +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
  --period 300 \
  --statistics "Sum"
```

### C. Références

- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation AWS](https://docs.aws.amazon.com)
- [Documentation OpenAI API](https://platform.openai.com/docs/guides/images)
- [Documentation Terraform](https://www.terraform.io/docs)
- [Documentation Firebase](https://firebase.google.com/docs)