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
}
