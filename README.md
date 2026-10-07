# NOVA (نوفا) - Mobile Application 🌟

**نوفا (NOVA)** هو تطبيق تعليمي تكيفي مصمم خصيصاً للأطفال على طيف التوحد لدعم مهاراتهم الإدراكية واللغوية والحركية عبر أنشطة تفاعلية هادئة ومخصصة بالذكاء الاصطناعي، مع تمكين الوالدين من متابعة تقدم أطفالهم عبر لوحات بيانية مفصلة.

> ⚠️ **تنبيه قانوني وطبي:** منصة NOVA أداة تعليمية ودعم سلوكي، وليست أداة تشخيص طبي أو سريري.

---

## 🛠 التقنيات المستخدمة (Tech Stack)

- **Framework**: Flutter (Dart 3 with full null-safety)
- **Architecture**: Feature-first Clean Architecture (`data` / `domain` / `presentation`)
- **State Management**: `flutter_bloc` (Cubit للواجهات البسيطة، Bloc للتدفقات المعقدة)
- **Dependency Injection**: `get_it`
- **Networking**: `dio` with Interceptors (JWT token auto-refresh & redaction)
- **Error Handling**: `fpdart` (`Either<Failure, T>`)
- **Storage**: `flutter_secure_storage` (رموز المصادقة)، `shared_preferences` (الإعدادات)
- **Charts & Audio**: `fl_chart`, `flutter_tts` (Arabic Text-to-Speech)
- **Localization**: `flutter_localizations` + ARB (اللغة العربية افتراضياً مع دعم كامل لـ RTL)
- **Testing**: `bloc_test`, `mocktail`

---

## 📁 هيكلية المشروع (Project Structure)

```text
lib/
├── app.dart                  # تهيئة التطبيق، الثيم، وتوجيه المسارات
├── main.dart                 # نقطة الانطلاق مع runZonedGuarded ومراقب الأخطاء
├── core/                     # المكونات المشتركة
│   ├── di/                   # حقن التبعيات (GetIt service locator)
│   ├── error/                # نماذج الأخطاء (Failures) ومحول الرسائل العربية
│   ├── l10n/                 # دعم اللغة العربية وملفات ARB
│   ├── network/              # عميل Dio، معترضات المصادقة، وبيئة التشغيل (AppConfig)
│   ├── router/               # مسارات GoRouter مع حماية الدخول والروابط العميقة
│   ├── services/             # خدمات النظام (AppLogger, CrashReporter, TtsService)
│   ├── storage/              # التخزين الآمن والمحلي (SecureStorage, Prefs)
│   ├── theme/                # نظام التصميم، الألوان المهدئة، المسافات، والخطوط
│   ├── utils/                # أدوات المساعدة والحركة الآمنة (NovaMotion)
│   └── widgets/              # العناصر المشتركة (ParentGateDialog, Loading, Error, Empty)
└── features/                 # ميزات التطبيق (مقسمة Clean Architecture)
    ├── onboarding/           # جولة التعريف بالتطبيق
    ├── auth/                 # تسجيل الدخول، إنشاء الحساب، واستعادة الجلسة
    ├── children/             # إدارة ملفات الأطفال وبياناتهم
    ├── home/                 # الشاشة الرئيسية ولوحة تحكم الطفل
    ├── skills/               # المهارات التعليمية
    ├── activity/             # مشغل الأنشطة التفاعلي، استجابة الإجابات، والنتائج
    ├── progress/             # رسوم التقارير البيانية وتاريخ الجلسات
    └── settings/             # الإعدادات (الصوت، القراءة، تقليل الحركة، وحجم الخط)
```

---

## 🚀 التثبيت والتشغيل (Getting Started)

### 1. تثبيت الحزم وتوليد الكود

```bash
# تحميل الحزم
flutter pub get

# تشغيل build_runner لتوليد نماذج Freezed و JSON
dart run build_runner build --delete-conflicting-outputs
```

### 2. التشغيل مع تحديد عنوان السيرفر (`BASE_URL`)

```bash
# التشغيل على محاكي أندرويد مع خادم محلي
flutter run --dart-define=BASE_URL=http://10.0.2.2:3000/api/v1

# التشغيل على هاتف حقيقي عبر شبكة Wi-Fi
flutter run --dart-define=BASE_URL=http://192.168.1.6:3000/api/v1
```

### 3. التشغيل في وضع المحاكاة بدون خادم (`USE_MOCK`)

يمكن تشغيل التطبيق بالكامل وتجربة الأنشطة الذكية وتوليدها محلياً دون الحاجة لاتصال بالخادم:

```bash
flutter run --dart-define=USE_MOCK=true
```

### 4. التشغيل لبيئة الإنتاج (`Production`)

```bash
flutter run --dart-define=APP_FLAVOR=prod --dart-define=BASE_URL=https://api.nova-learn.com/api/v1
```

---

## 🧩 كيفية إضافة ميزة جديدة (Adding a New Feature)

عند إضافة ميزة جديدة، التزم بنمط **Clean Architecture** داخل مجلد `lib/features/<feature_name>` عبر الطبقات التالية:

1. **Domain Layer (طبقة الأعمال والمجال):**
   - أنشئ الكيانات `domain/entities/<entity>.dart` (بيانات نقية بدون مكتبات خارجية).
   - عرّف واجهة المستودع `domain/repositories/<feature>_repository.dart` تعيد `Future<Either<Failure, T>>`.
   - أنشئ حالات الاستخدام `domain/usecases/<action>_use_case.dart`.

2. **Data Layer (طبقة البيانات):**
   - أنشئ مصدر البيانات البعيد `data/datasources/<feature>_remote_data_source.dart` مستخدماً `sl<Dio>()`.
   - نفّذ واجهة المستودع `data/repositories/<feature>_repository_impl.dart` مع معالجة استثناءات Dio عبر `ErrorMapper`.

3. **Presentation Layer (طبقة العرض والواجهة):**
   - أنشئ الـ Cubit أو الـ Bloc وحالاته في `presentation/cubit/`.
   - صمم الواجهات والعناصر في `presentation/pages/` و `presentation/widgets/`.
   - تأكد من توفير الحالات الثلاث الإلزامية: `LoadingView`، `ErrorView` (مع إعادة المحاولة)، و `EmptyView`.
   - استخدم أهداف لمس واسعة (≥ 64dp للأطفال، ≥ 48dp للبالغين)، وألوان ناعمة بدون أحمر للمحاولة الخاطئة.

4. **التسجيل في حقن التبعيات (Dependency Injection):**
   - أضف دالة `register<Feature>Feature(GetIt sl)` في `lib/core/di/injection.dart` واستدعها في `configureDependencies()`.

5. **إضافة المسار في الراوتر (GoRouter):**
   - أضف اسم المسار في `lib/core/router/route_names.dart` والمسار في `lib/core/router/app_router.dart`.

---

## ♿ إرشادات إمكانية الوصول وسلامة الحركة (Accessibility & Motion)

- **دعم قارئ الشاشة (TalkBack / VoiceOver):** جميع الأزرار والنجوم وخيارات الأسئلة مغلفة بـ `Semantics` واضحة باللغة العربية.
- **سلامة الحركة (Sensory-friendly Motion):**
  - لا توجد ومضات أو تحركات أسرع من دورة واحدة كل 2.5 ثانية (≥ 2000ms).
  - عند تفعيل خيار "تقليل الحركة" من إعدادات التطبيق أو نظام التشغيل، يتم كتم جميع الحركات تلقائياً عبر `NovaMotion`.
- **تباين النصوص:** تباين جميع النصوص مع الخلفية يتجاوز معيار WCAG AA (≥ 4.5:1).
- **تكبير الخط:** دعم تكبير الخطوط حتى 1.5x دون أي تجاوز للشاشة (Overflow) باستخدام الحاويات المرنة والتمرير الآمن.

---

## 🧪 الفحص والاختبارات (Verification & Quality)

```bash
# التحقق من خلو الكود من التحذيرات
flutter analyze

# تنسيق الكود
dart format .

# تشغيل جميع اختبارات الوحدة والواجهات
flutter test
```
