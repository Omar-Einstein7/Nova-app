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

  @override
  String get addChildButton => 'إضافة طفل';

  @override
  String get addChildTitle => 'إضافة طفل جديد';

  @override
  String get editChildTitle => 'تعديل بيانات الطفل';

  @override
  String get homeNoChildren =>
      'لم تقم بإضافة أي طفل بعد.\nابدأ بإضافة طفلك الأول لاكتشاف الأنشطة التعليمية.';

  @override
  String get deleteChildTitle => 'حذف الملف';

  @override
  String deleteChildConfirm(String name) {
    return 'هل أنت متأكد من حذف ملف $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String childAgeLabel(int age) {
    return '$age سنوات';
  }

  @override
  String get childNameLabel => 'اسم الطفل';

  @override
  String get childNameHint => 'مثال: عمر';

  @override
  String get childNameTooLong => 'يجب ألا يتجاوز الاسم 40 حرفاً.';

  @override
  String get birthDateLabel => 'تاريخ الميلاد';

  @override
  String get selectBirthDate => 'اختر تاريخ الميلاد';

  @override
  String get childAgeOutOfRange => 'يجب أن يكون عمر الطفل بين 3 و18 سنة.';

  @override
  String get avatarLabel => 'اختر صورة تعبيرية';

  @override
  String get interestsLabel => 'الاهتمامات';

  @override
  String get interestsHint =>
      'اختر اهتمامات طفلك لتخصيص الأنشطة (حتى 10 اهتمامات)';

  @override
  String get addCustomInterestHint => 'إضافة اهتمام مخصص…';

  @override
  String get learningStyleLabel => 'أسلوب التعلم المفضل';

  @override
  String get learningStyleVisual => 'بصري';

  @override
  String get learningStyleVisualDesc =>
      'يتعلم بشكل أفضل من خلال الصور والرموز والأشكال';

  @override
  String get learningStyleAuditory => 'سمعي';

  @override
  String get learningStyleAuditoryDesc =>
      'يتعلم بشكل أفضل من خلال الصوت والتوجيه السمعي';

  @override
  String get learningStyleMixed => 'مختلط';

  @override
  String get learningStyleMixedDesc => 'مزيج متوازن بين البصري والسمعي';

  @override
  String get selectSkillsLabel => 'المهارات المستهدفة';

  @override
  String get selectSkillsHint => 'حدد المهارات التي تود التركيز عليها';

  @override
  String get selectLearningStyle => 'يرجى تحديد أسلوب التعلم';

  @override
  String get selectAtLeastOneSkill => 'يرجى اختيار مهارة واحدة على الأقل';

  @override
  String get childSavedSuccess => 'تم حفظ بيانات الطفل بنجاح';

  @override
  String get maxChildrenReached =>
      'لقد وصلت إلى الحد الأقصى للأطفال (5 أطفال).';

  @override
  String get back => 'السابق';

  @override
  String get save => 'حفظ';

  @override
  String get startPlay => 'ابدأ النشاط';

  @override
  String get todaySuggestion => 'اقتراح اليوم';

  @override
  String get generalSkill => 'مهارة عامة';

  @override
  String get chooseSkill => 'اختر مهارة أخرى';

  @override
  String get suggestBreak => 'يُفضل أخذ استراحة قصيرة';

  @override
  String get progressUnavailable => 'بيانات التقدم غير متوفرة حالياً';

  @override
  String get statSessions => 'الجلسات';

  @override
  String get statStreak => 'أيام متتالية';

  @override
  String get statSuccess => 'نسبة النجاح';

  @override
  String get viewFullProgress => 'عرض سجل التقدم الكامل';

  @override
  String get activityGenerating => 'بنجهز لك نشاط جميل...';

  @override
  String get activityGeneratingPatience => 'لسّه شوية... شكراً لصبرك 😊';

  @override
  String get activityStartButton => 'ابدأ اللعب 🚀';

  @override
  String get activityNextButton => 'التالي ➡️';

  @override
  String get activityRetryButton => 'حاول مرة أخرى 💪';

  @override
  String get activityFinishButton => 'اعرض النتيجة 🎉';

  @override
  String get activityPlayAgain => 'نشاط آخر 🎮';

  @override
  String get activityGoHome => 'العودة للرئيسية';

  @override
  String get activityExitTitle => 'خروج من النشاط';

  @override
  String get activityExitConfirm => 'تحب تكمل ولا تخرج؟';

  @override
  String get activityExitContinue => 'أكمل';

  @override
  String get activityExitLeave => 'اخرج';

  @override
  String get activityResultExcellent => 'ممتاز! 🏆';

  @override
  String get activityResultGood => 'أحسنت! 🌟';

  @override
  String get activityResultOk => 'جيد! استمر 💙';

  @override
  String get activityResultSuccessRate => 'نسبة الإجابات الصحيحة';

  @override
  String get activityResultStars => 'النجوم المكتسبة';

  @override
  String activityLevelUp(String from, String to) {
    return 'ارتقيت من $from إلى $to!';
  }

  @override
  String get activityBreakSuggestion =>
      'يُفضل أخذ استراحة قصيرة قبل النشاط القادم';

  @override
  String get skillLevelBeginner => 'مبتدئ';

  @override
  String get skillLevelIntermediate => 'متوسط';

  @override
  String get skillLevelAdvanced => 'متقدم';

  @override
  String get chooseSkillTitle => 'اختر مهارة';

  @override
  String get randomActivity => 'نشاط عشوائي 🎲';

  @override
  String questionOf(int current, int total) {
    return 'سؤال $current من $total';
  }
}
