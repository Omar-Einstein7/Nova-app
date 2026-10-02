import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// Application name
  ///
  /// In ar, this message translates to:
  /// **'نوفا'**
  String get appName;

  /// Retry button label
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالإنترنت. تحقق من اتصالك وحاول مجدداً.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الاتصال. يرجى المحاولة مجدداً.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في الخادم: {message}'**
  String errorServer(String message);

  /// No description provided for @errorUnauthorized.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'البيانات المدخلة غير صحيحة.'**
  String get errorValidation;

  /// No description provided for @emptyDefault.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات لعرضها.'**
  String get emptyDefault;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get registerTitle;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get nameLabel;

  /// No description provided for @continueLabel.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueLabel;

  /// No description provided for @homeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeTitle;

  /// No description provided for @sessionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت جلستك. يرجى تسجيل الدخول مجدداً.'**
  String get sessionExpired;

  /// No description provided for @parentGateTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من هوية ولي الأمر'**
  String get parentGateTitle;

  /// No description provided for @parentGateQuestion.
  ///
  /// In ar, this message translates to:
  /// **'كم يساوي {a} + {b}؟'**
  String parentGateQuestion(int a, int b);

  /// No description provided for @parentGateHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الإجابة'**
  String get parentGateHint;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @progressTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقدم'**
  String get progressTitle;

  /// No description provided for @childrenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأطفال'**
  String get childrenTitle;

  /// No description provided for @activityTitle.
  ///
  /// In ar, this message translates to:
  /// **'النشاط'**
  String get activityTitle;

  /// No description provided for @stars.
  ///
  /// In ar, this message translates to:
  /// **'{count} نجوم'**
  String stars(int count);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في نوفا'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق تعليمي تكيّفي مصمم لدعم أطفالك.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطى'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingStart;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In ar, this message translates to:
  /// **'تعلُّم مُصمَّم لطفلك'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In ar, this message translates to:
  /// **'تنشئ نوفا أنشطة تعليمية مخصصة تتكيّف مع أسلوب تعلم طفلك واهتماماته.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In ar, this message translates to:
  /// **'رحلة آمنة وهادئة'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In ar, this message translates to:
  /// **'بيئة تعليمية لطيفة بدون ضغط أو إشارات سلبية — فقط الدعم والتشجيع.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In ar, this message translates to:
  /// **'تابع تقدّم طفلك'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In ar, this message translates to:
  /// **'تقارير واضحة ومفيدة تُظهر لك نمو طفلك وتوصيات النشاط القادم.'**
  String get onboardingSlide3Body;

  /// No description provided for @splashTagline.
  ///
  /// In ar, this message translates to:
  /// **'التعلم بأسلوبك'**
  String get splashTagline;

  /// No description provided for @loginEmailHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حساباً'**
  String get loginCreateAccount;

  /// No description provided for @loginWrongCredentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو كلمة المرور غير صحيحة.'**
  String get loginWrongCredentials;

  /// No description provided for @registerNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك الكامل'**
  String get registerNameHint;

  /// No description provided for @registerButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get registerButton;

  /// No description provided for @registerHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get registerHaveAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك'**
  String get registerSignIn;

  /// No description provided for @registerEmailExists.
  ///
  /// In ar, this message translates to:
  /// **'هذا البريد الإلكتروني مستخدم بالفعل. يرجى تسجيل الدخول.'**
  String get registerEmailExists;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In ar, this message translates to:
  /// **'بإنشاء حساب، أنت توافق على '**
  String get registerTermsPrefix;

  /// No description provided for @registerTermsLink.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get registerTermsLink;

  /// No description provided for @registerTermsAnd.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get registerTermsAnd;

  /// No description provided for @registerPrivacyLink.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get registerPrivacyLink;

  /// No description provided for @validationEmailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مطلوب.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور مطلوبة.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordWeak.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وتشمل حرفاً ورقماً.'**
  String get validationPasswordWeak;

  /// No description provided for @validationNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم مطلوب.'**
  String get validationNameRequired;

  /// No description provided for @validationNameLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يكون الاسم بين 2 و60 حرفاً.'**
  String get validationNameLength;

  /// No description provided for @showPassword.
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة المرور'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة المرور'**
  String get hidePassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
