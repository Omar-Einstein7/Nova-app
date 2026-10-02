// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'نوفا';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get errorGeneric => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errorNetwork =>
      'تعذّر الاتصال بالإنترنت. تحقق من اتصالك وحاول مجدداً.';

  @override
  String get errorTimeout => 'انتهت مهلة الاتصال. يرجى المحاولة مجدداً.';

  @override
  String errorServer(String message) {
    return 'حدث خطأ في الخادم: $message';
  }

  @override
  String get errorUnauthorized => 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get errorValidation => 'البيانات المدخلة غير صحيحة.';

  @override
  String get emptyDefault => 'لا توجد بيانات لعرضها.';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.';

  @override
  String get parentGateTitle => 'تحقق من هوية ولي الأمر';

  @override
  String parentGateQuestion(int a, int b) {
    return 'كم يساوي $a + $b؟';
  }

  @override
  String get parentGateHint => 'أدخل الإجابة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get progressTitle => 'التقدم';

  @override
  String get childrenTitle => 'الأطفال';

  @override
  String get activityTitle => 'النشاط';

  @override
  String stars(int count) {
    return '$count نجوم';
  }

  @override
  String get onboardingWelcomeTitle => 'مرحباً بك في نوفا';

  @override
  String get onboardingWelcomeBody => 'تطبيق تعليمي تكيّفي مصمم لدعم أطفالك.';

  @override
  String get onboardingSkip => 'تخطى';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingStart => 'ابدأ الآن';

  @override
  String get onboardingSlide1Title => 'تعلُّم مُصمَّم لطفلك';

  @override
  String get onboardingSlide1Body =>
      'تنشئ نوفا أنشطة تعليمية مخصصة تتكيّف مع أسلوب تعلم طفلك واهتماماته.';

  @override
  String get onboardingSlide2Title => 'رحلة آمنة وهادئة';

  @override
  String get onboardingSlide2Body =>
      'بيئة تعليمية لطيفة بدون ضغط أو إشارات سلبية — فقط الدعم والتشجيع.';

  @override
  String get onboardingSlide3Title => 'تابع تقدّم طفلك';

  @override
  String get onboardingSlide3Body =>
      'تقارير واضحة ومفيدة تُظهر لك نمو طفلك وتوصيات النشاط القادم.';

  @override
  String get splashTagline => 'التعلم بأسلوبك';

  @override
  String get loginEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get loginPasswordHint => 'أدخل كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get loginCreateAccount => 'أنشئ حساباً';

  @override
  String get loginWrongCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get registerNameHint => 'أدخل اسمك الكامل';

  @override
  String get registerButton => 'إنشاء الحساب';

  @override
  String get registerHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get registerSignIn => 'سجّل دخولك';

  @override
  String get registerEmailExists =>
      'هذا البريد الإلكتروني مستخدم بالفعل. يرجى تسجيل الدخول.';

  @override
  String get registerTermsPrefix => 'بإنشاء حساب، أنت توافق على ';

  @override
  String get registerTermsLink => 'شروط الاستخدام';

  @override
  String get registerTermsAnd => ' و';

  @override
  String get registerPrivacyLink => 'سياسة الخصوصية';

  @override
  String get validationEmailRequired => 'البريد الإلكتروني مطلوب.';

  @override
  String get validationEmailInvalid => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get validationPasswordRequired => 'كلمة المرور مطلوبة.';

  @override
  String get validationPasswordWeak =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وتشمل حرفاً ورقماً.';

  @override
  String get validationNameRequired => 'الاسم مطلوب.';

  @override
  String get validationNameLength => 'يجب أن يكون الاسم بين 2 و60 حرفاً.';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';
}
