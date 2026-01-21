import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The title of the application
  ///
  /// In pt, this message translates to:
  /// **'BurgerRats'**
  String get appTitle;

  /// Welcome message
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo'**
  String get welcome;

  /// Login button text
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get login;

  /// Logout button text
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// Register button text
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get register;

  /// Email field label
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// Password field label
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// Confirm password field label
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu a senha?'**
  String get forgotPassword;

  /// Home navigation item
  ///
  /// In pt, this message translates to:
  /// **'Inicio'**
  String get home;

  /// Profile navigation item
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Settings navigation item
  ///
  /// In pt, this message translates to:
  /// **'Configuracoes'**
  String get settings;

  /// Loading indicator text
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// Generic error title
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// Try again button text
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// Cancel button text
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Save button text
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// Delete button text
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// Confirm button text
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// Login page subtitle
  ///
  /// In pt, this message translates to:
  /// **'Entre para avaliar hamburguerias'**
  String get loginSubtitle;

  /// Email field hint
  ///
  /// In pt, this message translates to:
  /// **'seu@email.com'**
  String get emailHint;

  /// Divider text between login options
  ///
  /// In pt, this message translates to:
  /// **'ou'**
  String get or;

  /// Google sign-in button text
  ///
  /// In pt, this message translates to:
  /// **'Continuar com Google'**
  String get continueWithGoogle;

  /// Create account button text
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get createAccount;

  /// Register page subtitle
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta para comecar a avaliar hamburguerias e competir com seus amigos!'**
  String get registerSubtitle;

  /// Name field label
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// Name field hint
  ///
  /// In pt, this message translates to:
  /// **'Seu nome'**
  String get nameHint;

  /// Password minimum characters helper text
  ///
  /// In pt, this message translates to:
  /// **'Minimo 6 caracteres'**
  String get passwordMinChars;

  /// Terms acceptance prefix text
  ///
  /// In pt, this message translates to:
  /// **'Li e aceito os '**
  String get acceptTermsText;

  /// Terms of use link text
  ///
  /// In pt, this message translates to:
  /// **'Termos de Uso'**
  String get termsOfUse;

  /// Conjunction between terms and privacy
  ///
  /// In pt, this message translates to:
  /// **' e a '**
  String get and;

  /// Privacy policy link text
  ///
  /// In pt, this message translates to:
  /// **'Politica de Privacidade'**
  String get privacyPolicy;

  /// Terms acceptance validation error
  ///
  /// In pt, this message translates to:
  /// **'Voce deve aceitar os termos de uso'**
  String get mustAcceptTerms;

  /// Already have account text
  ///
  /// In pt, this message translates to:
  /// **'Ja tem uma conta?'**
  String get alreadyHaveAccount;

  /// Recover password page title
  ///
  /// In pt, this message translates to:
  /// **'Recuperar senha'**
  String get recoverPassword;

  /// Forgot password page title
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu sua senha?'**
  String get forgotPasswordTitle;

  /// Forgot password page description
  ///
  /// In pt, this message translates to:
  /// **'Digite seu e-mail e enviaremos um link para voce redefinir sua senha.'**
  String get forgotPasswordDescription;

  /// Send reset link button text
  ///
  /// In pt, this message translates to:
  /// **'Enviar link'**
  String get sendLink;

  /// Back to login button text
  ///
  /// In pt, this message translates to:
  /// **'Voltar para login'**
  String get backToLogin;

  /// Email sent success title
  ///
  /// In pt, this message translates to:
  /// **'E-mail enviado!'**
  String get emailSent;

  /// Recovery link sent message
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um link de recuperacao para:'**
  String get recoveryLinkSentTo;

  /// Check inbox and spam folder message
  ///
  /// In pt, this message translates to:
  /// **'Verifique sua caixa de entrada e a pasta de spam.'**
  String get checkInboxAndSpam;

  /// Resend email link text
  ///
  /// In pt, this message translates to:
  /// **'Nao recebeu? Enviar novamente'**
  String get didNotReceiveResend;

  /// My leagues page title
  ///
  /// In pt, this message translates to:
  /// **'Minhas Ligas'**
  String get myLeagues;

  /// Join league button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Entrar em uma liga'**
  String get joinLeague;

  /// New league FAB label
  ///
  /// In pt, this message translates to:
  /// **'Nova Liga'**
  String get newLeague;

  /// Singular member text
  ///
  /// In pt, this message translates to:
  /// **'membro'**
  String get member;

  /// Plural members text
  ///
  /// In pt, this message translates to:
  /// **'membros'**
  String get members;

  /// Just now time text
  ///
  /// In pt, this message translates to:
  /// **'Agora mesmo'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In pt, this message translates to:
  /// **'Ha {minutes} min'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In pt, this message translates to:
  /// **'Ha {hours}h'**
  String hoursAgo(int hours);

  /// Yesterday time text
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// Days ago time text
  ///
  /// In pt, this message translates to:
  /// **'Ha {days} dias'**
  String daysAgo(int days);

  /// Week ago time text (singular)
  ///
  /// In pt, this message translates to:
  /// **'Ha {weeks} semana'**
  String weekAgo(int weeks);

  /// Weeks ago time text (plural)
  ///
  /// In pt, this message translates to:
  /// **'Ha {weeks} semanas'**
  String weeksAgo(int weeks);

  /// Month ago time text (singular)
  ///
  /// In pt, this message translates to:
  /// **'Ha {months} mes'**
  String monthAgo(int months);

  /// Months ago time text (plural)
  ///
  /// In pt, this message translates to:
  /// **'Ha {months} meses'**
  String monthsAgo(int months);

  /// Year ago time text (singular)
  ///
  /// In pt, this message translates to:
  /// **'Ha {years} ano'**
  String yearAgo(int years);

  /// Years ago time text (plural)
  ///
  /// In pt, this message translates to:
  /// **'Ha {years} anos'**
  String yearsAgo(int years);

  /// Empty leagues state title
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma liga ainda'**
  String get noLeaguesYet;

  /// Empty leagues state description
  ///
  /// In pt, this message translates to:
  /// **'Crie uma nova liga ou entre em uma existente usando um codigo de convite.'**
  String get createOrJoinLeague;

  /// Join button text
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get join;

  /// Create league button text
  ///
  /// In pt, this message translates to:
  /// **'Criar Liga'**
  String get createLeague;

  /// Error loading leagues message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar ligas'**
  String get errorLoadingLeagues;

  /// Check connection and try again message
  ///
  /// In pt, this message translates to:
  /// **'Verifique sua conexao e tente novamente.'**
  String get checkConnectionTryAgain;

  /// My check-ins page title
  ///
  /// In pt, this message translates to:
  /// **'Meus Check-ins'**
  String get myCheckIns;

  /// View as gallery button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Ver como galeria'**
  String get viewAsGallery;

  /// View as list button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Ver como lista'**
  String get viewAsList;

  /// Clear filters button text
  ///
  /// In pt, this message translates to:
  /// **'Limpar filtros'**
  String get clearFilters;

  /// Filter button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// No check-ins found with filters
  ///
  /// In pt, this message translates to:
  /// **'Nenhum check-in encontrado'**
  String get noCheckInsFound;

  /// No check-ins yet
  ///
  /// In pt, this message translates to:
  /// **'Nenhum check-in ainda'**
  String get noCheckInsYet;

  /// Adjust filters suggestion message
  ///
  /// In pt, this message translates to:
  /// **'Tente ajustar os filtros para ver mais resultados.'**
  String get adjustFiltersMessage;

  /// Make first check-in suggestion
  ///
  /// In pt, this message translates to:
  /// **'Faca seu primeiro check-in clicando no botao +'**
  String get makeFirstCheckIn;

  /// Error loading check-ins message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar check-ins'**
  String get errorLoadingCheckIns;

  /// Filters bottom sheet title
  ///
  /// In pt, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// Clear button text
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// League filter section title
  ///
  /// In pt, this message translates to:
  /// **'Liga'**
  String get league;

  /// Not part of any league message
  ///
  /// In pt, this message translates to:
  /// **'Voce ainda nao faz parte de nenhuma liga.'**
  String get notPartOfAnyLeague;

  /// All leagues filter option
  ///
  /// In pt, this message translates to:
  /// **'Todas as ligas'**
  String get allLeagues;

  /// Period filter section title
  ///
  /// In pt, this message translates to:
  /// **'Periodo'**
  String get period;

  /// Today filter option
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get today;

  /// This week filter option
  ///
  /// In pt, this message translates to:
  /// **'Esta semana'**
  String get thisWeek;

  /// This month filter option
  ///
  /// In pt, this message translates to:
  /// **'Este mes'**
  String get thisMonth;

  /// Last 30 days filter option
  ///
  /// In pt, this message translates to:
  /// **'Ultimos 30 dias'**
  String get last30Days;

  /// Start date picker label
  ///
  /// In pt, this message translates to:
  /// **'Data inicial'**
  String get startDate;

  /// End date picker label
  ///
  /// In pt, this message translates to:
  /// **'Data final'**
  String get endDate;

  /// Clear period button text
  ///
  /// In pt, this message translates to:
  /// **'Limpar periodo'**
  String get clearPeriod;

  /// Apply filters button text
  ///
  /// In pt, this message translates to:
  /// **'Aplicar filtros'**
  String get applyFilters;

  /// Error loading profile message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perfil'**
  String get errorLoadingProfile;

  /// Check-ins stat label
  ///
  /// In pt, this message translates to:
  /// **'Check-ins'**
  String get checkIns;

  /// Streak stat label
  ///
  /// In pt, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Leagues stat label
  ///
  /// In pt, this message translates to:
  /// **'Ligas'**
  String get leagues;

  /// Edit profile menu item
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// Check-in history menu item
  ///
  /// In pt, this message translates to:
  /// **'Historico de Check-ins'**
  String get checkInHistory;

  /// Logout confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja sair?'**
  String get logoutConfirmation;

  /// Notifications settings item
  ///
  /// In pt, this message translates to:
  /// **'Notificacoes'**
  String get notifications;

  /// Theme settings item
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get theme;

  /// Language settings item
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Portuguese language option
  ///
  /// In pt, this message translates to:
  /// **'Portugues'**
  String get portuguese;

  /// English language option
  ///
  /// In pt, this message translates to:
  /// **'Ingles'**
  String get english;

  /// About settings item
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// Version text
  ///
  /// In pt, this message translates to:
  /// **'Versao {version}'**
  String version(String version);

  /// Delete account settings item
  ///
  /// In pt, this message translates to:
  /// **'Excluir Conta'**
  String get deleteAccount;

  /// Delete account confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja excluir sua conta? Esta acao nao pode ser desfeita.'**
  String get deleteAccountConfirmation;

  /// Select theme dialog title
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Tema'**
  String get selectTheme;

  /// Light theme option
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get light;

  /// Dark theme option
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get dark;

  /// System theme option
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get system;

  /// Select language dialog title
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Idioma'**
  String get selectLanguage;

  /// Skip button text
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get skip;

  /// Next button text
  ///
  /// In pt, this message translates to:
  /// **'Proximo'**
  String get next;

  /// Start button text
  ///
  /// In pt, this message translates to:
  /// **'Comecar'**
  String get start;

  /// Onboarding page 1 title
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo ao BurgerRats!'**
  String get onboardingTitle1;

  /// Onboarding page 1 description
  ///
  /// In pt, this message translates to:
  /// **'Registre suas visitas a hamburguerias, avalie seus burgers favoritos e compartilhe suas experiencias com amigos.'**
  String get onboardingDescription1;

  /// Onboarding page 1 highlight
  ///
  /// In pt, this message translates to:
  /// **'Sua jornada burger comeca aqui!'**
  String get onboardingHighlight1;

  /// Onboarding page 2 title
  ///
  /// In pt, this message translates to:
  /// **'Compita em Ligas'**
  String get onboardingTitle2;

  /// Onboarding page 2 description
  ///
  /// In pt, this message translates to:
  /// **'Crie ou participe de ligas com seus amigos. Quem visitar mais hamburguerias no periodo da liga, ganha!'**
  String get onboardingDescription2;

  /// Onboarding page 2 highlight
  ///
  /// In pt, this message translates to:
  /// **'Forme sua equipe e suba no ranking!'**
  String get onboardingHighlight2;

  /// Onboarding page 3 title
  ///
  /// In pt, this message translates to:
  /// **'Faca Check-ins'**
  String get onboardingTitle3;

  /// Onboarding page 3 description
  ///
  /// In pt, this message translates to:
  /// **'Tire uma foto do seu burger, avalie de 1 a 5 estrelas e registre o nome da hamburgueria. Cada check-in vale pontos na liga!'**
  String get onboardingDescription3;

  /// Onboarding page 3 highlight
  ///
  /// In pt, this message translates to:
  /// **'Um check-in por dia por liga!'**
  String get onboardingHighlight3;

  /// Must be logged in message
  ///
  /// In pt, this message translates to:
  /// **'Voce precisa estar logado para criar uma liga'**
  String get mustBeLoggedIn;

  /// Create your league title
  ///
  /// In pt, this message translates to:
  /// **'Crie sua liga'**
  String get createYourLeague;

  /// Create league page description
  ///
  /// In pt, this message translates to:
  /// **'Reuna seus amigos e compitam para encontrar os melhores hamburgueres!'**
  String get createLeagueDescription;

  /// League name field label
  ///
  /// In pt, this message translates to:
  /// **'Nome da Liga'**
  String get leagueName;

  /// League name required validation message
  ///
  /// In pt, this message translates to:
  /// **'Nome da liga e obrigatorio'**
  String get leagueNameRequired;

  /// League name field hint
  ///
  /// In pt, this message translates to:
  /// **'Ex: Burguer Hunters'**
  String get leagueNameHint;

  /// Minimum characters required validation message
  ///
  /// In pt, this message translates to:
  /// **'Minimo de {min} caracteres'**
  String minCharsRequired(int min);

  /// Description field label
  ///
  /// In pt, this message translates to:
  /// **'Descricao (opcional)'**
  String get descriptionOptional;

  /// Description field hint
  ///
  /// In pt, this message translates to:
  /// **'Descreva sua liga...'**
  String get describeYourLeague;

  /// Configuration section title
  ///
  /// In pt, this message translates to:
  /// **'Configuracoes'**
  String get configuration;

  /// Public league toggle title
  ///
  /// In pt, this message translates to:
  /// **'Liga Publica'**
  String get publicLeague;

  /// Public league description
  ///
  /// In pt, this message translates to:
  /// **'Qualquer um pode encontrar sua liga'**
  String get anyoneCanFind;

  /// Private league description
  ///
  /// In pt, this message translates to:
  /// **'Apenas com codigo de convite'**
  String get inviteCodeOnly;

  /// Members can invite toggle title
  ///
  /// In pt, this message translates to:
  /// **'Membros podem convidar'**
  String get membersCanInvite;

  /// Members can share description
  ///
  /// In pt, this message translates to:
  /// **'Todos membros podem compartilhar o codigo'**
  String get allMembersCanShare;

  /// Only admins can invite description
  ///
  /// In pt, this message translates to:
  /// **'Apenas administradores podem convidar'**
  String get onlyAdminsCanInvite;

  /// Max members setting title
  ///
  /// In pt, this message translates to:
  /// **'Maximo de membros'**
  String get maxMembers;

  /// Members range description
  ///
  /// In pt, this message translates to:
  /// **'De {min} a {max} membros'**
  String fromToMembers(int min, int max);

  /// Unknown error message
  ///
  /// In pt, this message translates to:
  /// **'Erro desconhecido'**
  String get unknownError;

  /// Creating loading state
  ///
  /// In pt, this message translates to:
  /// **'Criando...'**
  String get creating;

  /// League created success title
  ///
  /// In pt, this message translates to:
  /// **'Liga Criada!'**
  String get leagueCreated;

  /// League created success message
  ///
  /// In pt, this message translates to:
  /// **'Sua liga \"{name}\" foi criada com sucesso!'**
  String leagueCreatedSuccess(String name);

  /// Invite code label
  ///
  /// In pt, this message translates to:
  /// **'Codigo de Convite'**
  String get inviteCode;

  /// Code copied snackbar message
  ///
  /// In pt, this message translates to:
  /// **'Codigo copiado!'**
  String get codeCopied;

  /// Tap to copy hint
  ///
  /// In pt, this message translates to:
  /// **'Toque para copiar'**
  String get tapToCopy;

  /// Share invite code instruction
  ///
  /// In pt, this message translates to:
  /// **'Compartilhe este codigo com seus amigos para que eles possam entrar na sua liga!'**
  String get shareInviteCode;

  /// Back button text
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// View league button text
  ///
  /// In pt, this message translates to:
  /// **'Ver Liga'**
  String get viewLeague;

  /// Required field validation message
  ///
  /// In pt, this message translates to:
  /// **'Este campo e obrigatorio.'**
  String get requiredField;

  /// Invalid email validation message
  ///
  /// In pt, this message translates to:
  /// **'O e-mail informado nao e valido.'**
  String get invalidEmail;

  /// Weak password validation message
  ///
  /// In pt, this message translates to:
  /// **'A senha e muito fraca. Use pelo menos 6 caracteres.'**
  String get weakPassword;

  /// Password mismatch validation message
  ///
  /// In pt, this message translates to:
  /// **'As senhas nao coincidem.'**
  String get passwordMismatch;

  /// Max length exceeded validation message
  ///
  /// In pt, this message translates to:
  /// **'Maximo de caracteres excedido.'**
  String get maxLengthExceeded;

  /// League details page title
  ///
  /// In pt, this message translates to:
  /// **'Detalhes da Liga'**
  String get leagueDetails;

  /// Share invite button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar Convite'**
  String get shareInvite;

  /// League not found error title
  ///
  /// In pt, this message translates to:
  /// **'Liga nao encontrada'**
  String get leagueNotFound;

  /// League not found error description
  ///
  /// In pt, this message translates to:
  /// **'A liga pode ter sido excluida ou voce nao tem acesso.'**
  String get leagueNotFoundDescription;

  /// Error loading league message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar liga'**
  String get errorLoadingLeague;

  /// Promote to admin menu item
  ///
  /// In pt, this message translates to:
  /// **'Promover a Admin'**
  String get promoteToAdmin;

  /// Remove admin menu item
  ///
  /// In pt, this message translates to:
  /// **'Remover Admin'**
  String get removeAdmin;

  /// Remove from league menu item
  ///
  /// In pt, this message translates to:
  /// **'Remover da Liga'**
  String get removeFromLeague;

  /// Transfer ownership menu item
  ///
  /// In pt, this message translates to:
  /// **'Transferir Propriedade'**
  String get transferOwnership;

  /// Promote to admin confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja promover {name} a admin? Admins podem gerenciar membros da liga.'**
  String promoteToAdminConfirmation(String name);

  /// Promote button text
  ///
  /// In pt, this message translates to:
  /// **'Promover'**
  String get promote;

  /// Promoting member loading message
  ///
  /// In pt, this message translates to:
  /// **'Promovendo membro...'**
  String get promotingMember;

  /// Remove admin confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja remover {name} como admin? Ele permanecera como membro da liga.'**
  String removeAdminConfirmation(String name);

  /// Removing admin loading message
  ///
  /// In pt, this message translates to:
  /// **'Removendo admin...'**
  String get removingAdmin;

  /// Remove member dialog title
  ///
  /// In pt, this message translates to:
  /// **'Remover Membro'**
  String get removeMember;

  /// Remove member confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja remover {name} da liga? Esta acao nao pode ser desfeita.'**
  String removeMemberConfirmation(String name);

  /// Remove button text
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// Removing member loading message
  ///
  /// In pt, this message translates to:
  /// **'Removendo membro...'**
  String get removingMember;

  /// Cannot leave league dialog title
  ///
  /// In pt, this message translates to:
  /// **'Nao e possivel sair'**
  String get cannotLeaveTitle;

  /// Cannot leave as only member message
  ///
  /// In pt, this message translates to:
  /// **'Voce e o unico membro da liga. Para sair, voce precisa excluir a liga.'**
  String get cannotLeaveOnlyMember;

  /// Understood button text
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get understood;

  /// Cannot leave as owner message
  ///
  /// In pt, this message translates to:
  /// **'Voce e o dono da liga. Para sair, voce precisa excluir a liga ou transferir a propriedade para outro membro.'**
  String get cannotLeaveOwner;

  /// Leave league menu item
  ///
  /// In pt, this message translates to:
  /// **'Sair da Liga'**
  String get leaveLeague;

  /// Leave league confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja sair desta liga? Seus pontos serao perdidos e esta acao nao pode ser desfeita.'**
  String get leaveLeagueConfirmation;

  /// Leave button text
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get leave;

  /// Leaving league loading message
  ///
  /// In pt, this message translates to:
  /// **'Saindo da liga...'**
  String get leavingLeague;

  /// Select new owner instruction
  ///
  /// In pt, this message translates to:
  /// **'Selecione o novo dono da liga:'**
  String get selectNewOwner;

  /// Confirm transfer dialog title
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Transferencia'**
  String get confirmTransfer;

  /// Transfer ownership confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja transferir a propriedade da liga para {name}?\n\nVoce se tornara um admin da liga.'**
  String transferOwnershipConfirmation(String name);

  /// Transfer button text
  ///
  /// In pt, this message translates to:
  /// **'Transferir'**
  String get transfer;

  /// Transferring ownership loading message
  ///
  /// In pt, this message translates to:
  /// **'Transferindo propriedade...'**
  String get transferringOwnership;

  /// League settings dialog/page title
  ///
  /// In pt, this message translates to:
  /// **'Configuracoes da Liga'**
  String get leagueSettings;

  /// Public league subtitle
  ///
  /// In pt, this message translates to:
  /// **'Visivel para todos os usuarios'**
  String get visibleToAllUsers;

  /// Points per check-in setting
  ///
  /// In pt, this message translates to:
  /// **'Pontos por Check-in'**
  String get pointsPerCheckIn;

  /// Points per review setting
  ///
  /// In pt, this message translates to:
  /// **'Pontos por Review'**
  String get pointsPerReview;

  /// Allows member invites subtitle
  ///
  /// In pt, this message translates to:
  /// **'Permite que membros compartilhem o convite'**
  String get allowsMemberInvites;

  /// Requires approval setting title
  ///
  /// In pt, this message translates to:
  /// **'Requer aprovacao'**
  String get requiresApproval;

  /// New members need approval subtitle
  ///
  /// In pt, this message translates to:
  /// **'Novos membros precisam de aprovacao'**
  String get newMembersNeedApproval;

  /// Saving settings loading message
  ///
  /// In pt, this message translates to:
  /// **'Salvando configuracoes...'**
  String get savingSettings;

  /// Delete league menu item
  ///
  /// In pt, this message translates to:
  /// **'Excluir Liga'**
  String get deleteLeague;

  /// Delete league confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir esta liga permanentemente? Todos os membros serao removidos e esta acao nao pode ser desfeita.'**
  String get deleteLeagueConfirmation;

  /// Deleting league loading message
  ///
  /// In pt, this message translates to:
  /// **'Excluindo liga...'**
  String get deletingLeague;

  /// Generate new code button text
  ///
  /// In pt, this message translates to:
  /// **'Gerar Novo Codigo'**
  String get generateNewCode;

  /// Generate new code confirmation message
  ///
  /// In pt, this message translates to:
  /// **'Deseja gerar um novo codigo de convite? O codigo antigo sera invalidado.'**
  String get generateNewCodeConfirmation;

  /// Generate button text
  ///
  /// In pt, this message translates to:
  /// **'Gerar'**
  String get generate;

  /// Generating new code loading message
  ///
  /// In pt, this message translates to:
  /// **'Gerando novo codigo...'**
  String get generatingNewCode;

  /// Owner role label
  ///
  /// In pt, this message translates to:
  /// **'Dono'**
  String get roleOwner;

  /// Admin role label
  ///
  /// In pt, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// Member role label
  ///
  /// In pt, this message translates to:
  /// **'Membro'**
  String get roleMember;

  /// Public label for league visibility
  ///
  /// In pt, this message translates to:
  /// **'Publica'**
  String get publicLabel;

  /// Private label for league visibility
  ///
  /// In pt, this message translates to:
  /// **'Privada'**
  String get privateLabel;

  /// Members count with max
  ///
  /// In pt, this message translates to:
  /// **'{count}/{max} membros'**
  String membersCount(int count, int max);

  /// Created on date text
  ///
  /// In pt, this message translates to:
  /// **'Criada em {date}'**
  String createdOn(String date);

  /// Statistics section title
  ///
  /// In pt, this message translates to:
  /// **'Estatisticas'**
  String get statistics;

  /// Total points stat label
  ///
  /// In pt, this message translates to:
  /// **'Total de Pontos'**
  String get totalPoints;

  /// Average per member stat label
  ///
  /// In pt, this message translates to:
  /// **'Media por Membro'**
  String get averagePerMember;

  /// Ranking section title
  ///
  /// In pt, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No members yet message
  ///
  /// In pt, this message translates to:
  /// **'Nenhum membro ainda'**
  String get noMembersYet;

  /// Make check-ins for points suggestion
  ///
  /// In pt, this message translates to:
  /// **'Faca check-ins para ganhar pontos!'**
  String get makeCheckInsForPoints;

  /// Tied status label
  ///
  /// In pt, this message translates to:
  /// **'Empatado'**
  String get tied;

  /// Loading ranking message
  ///
  /// In pt, this message translates to:
  /// **'Carregando ranking...'**
  String get loadingRanking;

  /// Error loading ranking message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar ranking'**
  String get errorLoadingRanking;

  /// Reminders menu item
  ///
  /// In pt, this message translates to:
  /// **'Lembretes'**
  String get reminders;

  /// Copy button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get copy;

  /// Yes text
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No text
  ///
  /// In pt, this message translates to:
  /// **'Nao'**
  String get no;

  /// Error message with details
  ///
  /// In pt, this message translates to:
  /// **'Erro: {message}'**
  String errorMessage(String message);

  /// Join league page title
  ///
  /// In pt, this message translates to:
  /// **'Entrar em Liga'**
  String get joinLeagueTitle;

  /// Enter invite code instruction
  ///
  /// In pt, this message translates to:
  /// **'Digite o codigo de convite'**
  String get enterInviteCode;

  /// Ask admin for code hint
  ///
  /// In pt, this message translates to:
  /// **'Peca ao administrador da liga o codigo de 8 caracteres'**
  String get askAdminForCode;

  /// Enter invite code validation error
  ///
  /// In pt, this message translates to:
  /// **'Insira o codigo de convite'**
  String get enterInviteCodeValidation;

  /// Code must have 8 characters validation error
  ///
  /// In pt, this message translates to:
  /// **'O codigo deve ter 8 caracteres'**
  String get codeMustHaveChars;

  /// Searching loading state
  ///
  /// In pt, this message translates to:
  /// **'Buscando...'**
  String get searching;

  /// Search league button text
  ///
  /// In pt, this message translates to:
  /// **'Buscar Liga'**
  String get searchLeague;

  /// Visibility label
  ///
  /// In pt, this message translates to:
  /// **'Visibilidade'**
  String get visibility;

  /// You joined success message
  ///
  /// In pt, this message translates to:
  /// **'Voce entrou!'**
  String get youJoined;

  /// Joining loading state
  ///
  /// In pt, this message translates to:
  /// **'Entrando...'**
  String get joining;

  /// Join the league button text
  ///
  /// In pt, this message translates to:
  /// **'Entrar na Liga'**
  String get joinTheLeague;

  /// Must be logged in to join message
  ///
  /// In pt, this message translates to:
  /// **'Voce precisa estar logado para entrar em uma liga'**
  String get mustBeLoggedInToJoin;

  /// Joined league success message
  ///
  /// In pt, this message translates to:
  /// **'Voce entrou na liga \"{name}\" com sucesso!'**
  String joinedLeagueSuccess(String name);

  /// Basic info section title
  ///
  /// In pt, this message translates to:
  /// **'Informacoes Basicas'**
  String get basicInfo;

  /// League name field label
  ///
  /// In pt, this message translates to:
  /// **'Nome da Liga'**
  String get leagueNameLabel;

  /// League name field hint
  ///
  /// In pt, this message translates to:
  /// **'Digite o nome da liga'**
  String get enterLeagueName;

  /// League name required validation
  ///
  /// In pt, this message translates to:
  /// **'O nome da liga e obrigatorio'**
  String get leagueNameRequiredValidation;

  /// Name must have at least 3 characters validation
  ///
  /// In pt, this message translates to:
  /// **'O nome deve ter pelo menos 3 caracteres'**
  String get nameMustHaveChars;

  /// Description field label
  ///
  /// In pt, this message translates to:
  /// **'Descricao'**
  String get description;

  /// Description field hint
  ///
  /// In pt, this message translates to:
  /// **'Digite uma descricao (opcional)'**
  String get enterDescriptionOptional;

  /// No permission title
  ///
  /// In pt, this message translates to:
  /// **'Sem permissao'**
  String get noPermission;

  /// Only admins can access settings message
  ///
  /// In pt, this message translates to:
  /// **'Apenas administradores podem acessar as configuracoes da liga.'**
  String get onlyAdminsCanAccessSettings;

  /// Error loading settings message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar configuracoes'**
  String get errorLoadingSettings;

  /// Saving changes loading message
  ///
  /// In pt, this message translates to:
  /// **'Salvando alteracoes...'**
  String get savingChanges;

  /// Changes saved success message
  ///
  /// In pt, this message translates to:
  /// **'Alteracoes salvas com sucesso!'**
  String get changesSavedSuccess;

  /// Save changes button text
  ///
  /// In pt, this message translates to:
  /// **'Salvar Alteracoes'**
  String get saveChanges;

  /// Discard changes dialog title
  ///
  /// In pt, this message translates to:
  /// **'Descartar alteracoes?'**
  String get discardChanges;

  /// Unsaved changes warning message
  ///
  /// In pt, this message translates to:
  /// **'Voce tem alteracoes nao salvas. Deseja descarta-las?'**
  String get unsavedChangesWarning;

  /// Continue editing button text
  ///
  /// In pt, this message translates to:
  /// **'Continuar Editando'**
  String get continueEditing;

  /// Discard button text
  ///
  /// In pt, this message translates to:
  /// **'Descartar'**
  String get discard;

  /// You label for current user
  ///
  /// In pt, this message translates to:
  /// **'(voce)'**
  String get youLabel;

  /// Share league invite message
  ///
  /// In pt, this message translates to:
  /// **'Junte-se a minha liga \"{name}\" no BurgerRats! {link}\n\nCodigo de convite: {code}'**
  String shareLeagueInviteMessage(String name, String link, String code);

  /// League invite share subject
  ///
  /// In pt, this message translates to:
  /// **'Convite para Liga - {name}'**
  String leagueInviteSubject(String name);

  /// Check-in details page title
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do Check-in'**
  String get checkInDetails;

  /// Share button tooltip
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get share;

  /// Generating shareable image message
  ///
  /// In pt, this message translates to:
  /// **'Gerando imagem compartilhavel...'**
  String get generatingShareableImage;

  /// Note section title
  ///
  /// In pt, this message translates to:
  /// **'Nota'**
  String get note;

  /// Details section title
  ///
  /// In pt, this message translates to:
  /// **'Detalhes'**
  String get details;

  /// Check-in not found title
  ///
  /// In pt, this message translates to:
  /// **'Check-in nao encontrado'**
  String get checkInNotFound;

  /// Check-in not found description
  ///
  /// In pt, this message translates to:
  /// **'Este check-in pode ter sido removido ou o link esta incorreto.'**
  String get checkInNotFoundDescription;

  /// Error loading check-in message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar check-in'**
  String get errorLoadingCheckIn;

  /// New check-in page title
  ///
  /// In pt, this message translates to:
  /// **'Novo Check-in'**
  String get newCheckIn;

  /// Select league section title
  ///
  /// In pt, this message translates to:
  /// **'Selecione a Liga'**
  String get selectLeague;

  /// Details optional section title
  ///
  /// In pt, this message translates to:
  /// **'Detalhes (opcional)'**
  String get detailsOptional;

  /// Restaurant name field label
  ///
  /// In pt, this message translates to:
  /// **'Nome do Restaurante'**
  String get restaurantName;

  /// Restaurant name field hint
  ///
  /// In pt, this message translates to:
  /// **'Ex: Burger King'**
  String get restaurantNameHint;

  /// Observation field label
  ///
  /// In pt, this message translates to:
  /// **'Observacao'**
  String get observation;

  /// Observation field hint
  ///
  /// In pt, this message translates to:
  /// **'Conte sobre sua experiencia...'**
  String get observationHint;

  /// Processing text
  ///
  /// In pt, this message translates to:
  /// **'Processando...'**
  String get processing;

  /// Make check-in button text
  ///
  /// In pt, this message translates to:
  /// **'Fazer Check-in'**
  String get makeCheckIn;

  /// Cannot check-in message
  ///
  /// In pt, this message translates to:
  /// **'Nao e possivel fazer check-in: {message}'**
  String cannotCheckIn(String message);

  /// Take photo to check-in hint
  ///
  /// In pt, this message translates to:
  /// **'Tire uma foto do seu burger para fazer check-in'**
  String get takePhotoToCheckIn;

  /// Select league to check-in hint
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma liga para fazer check-in'**
  String get selectLeagueToCheckIn;

  /// Join a league button text
  ///
  /// In pt, this message translates to:
  /// **'Entrar em uma Liga'**
  String get joinALeague;

  /// Must be logged in to check-in message
  ///
  /// In pt, this message translates to:
  /// **'Voce precisa estar logado para fazer check-in.'**
  String get mustBeLoggedInToCheckIn;

  /// Check-in success message
  ///
  /// In pt, this message translates to:
  /// **'Check-in realizado com sucesso!'**
  String get checkInSuccess;

  /// Error capturing photo message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao capturar foto: {error}'**
  String errorCapturingPhoto(String error);

  /// Take burger photo button text
  ///
  /// In pt, this message translates to:
  /// **'Tirar Foto do Burger'**
  String get takeBurgerPhoto;

  /// Tap to add photo hint
  ///
  /// In pt, this message translates to:
  /// **'Toque para adicionar uma foto'**
  String get tapToAddPhoto;

  /// Available for check-in status
  ///
  /// In pt, this message translates to:
  /// **'Disponivel para check-in'**
  String get availableForCheckIn;

  /// One check-in per day per league message
  ///
  /// In pt, this message translates to:
  /// **'Voce pode fazer 1 check-in por dia nesta liga'**
  String get oneCheckInPerDayPerLeague;

  /// Daily limit reached status
  ///
  /// In pt, this message translates to:
  /// **'Limite diario atingido'**
  String get dailyLimitReached;

  /// Already checked in today message
  ///
  /// In pt, this message translates to:
  /// **'Voce ja fez check-in hoje nesta liga.'**
  String get alreadyCheckedInToday;

  /// Change photo button text
  ///
  /// In pt, this message translates to:
  /// **'Trocar'**
  String get changePhoto;

  /// Error loading image message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar imagem'**
  String get errorLoadingImage;

  /// Photo added indicator text
  ///
  /// In pt, this message translates to:
  /// **'Foto adicionada'**
  String get photoAdded;

  /// Rating label
  ///
  /// In pt, this message translates to:
  /// **'Avaliacao'**
  String get ratingLabel;

  /// Tap stars to rate hint
  ///
  /// In pt, this message translates to:
  /// **'Toque nas estrelas para avaliar'**
  String get tapStarsToRate;

  /// Rating 1 label
  ///
  /// In pt, this message translates to:
  /// **'Ruim'**
  String get ratingBad;

  /// Rating 2 label
  ///
  /// In pt, this message translates to:
  /// **'Regular'**
  String get ratingRegular;

  /// Rating 3 label
  ///
  /// In pt, this message translates to:
  /// **'Bom'**
  String get ratingGood;

  /// Rating 4 label
  ///
  /// In pt, this message translates to:
  /// **'Muito bom'**
  String get ratingVeryGood;

  /// Rating 5 label
  ///
  /// In pt, this message translates to:
  /// **'Excelente'**
  String get ratingExcellent;

  /// Compressing photo message
  ///
  /// In pt, this message translates to:
  /// **'Comprimindo foto...'**
  String get compressingPhoto;

  /// Uploading photo message
  ///
  /// In pt, this message translates to:
  /// **'Enviando foto ({progress}%)...'**
  String uploadingPhoto(int progress);

  /// Saving check-in message
  ///
  /// In pt, this message translates to:
  /// **'Salvando check-in...'**
  String get savingCheckIn;

  /// Updating points message
  ///
  /// In pt, this message translates to:
  /// **'Atualizando pontos...'**
  String get updatingPoints;

  /// Error loading your leagues message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar suas ligas. Tente novamente.'**
  String get errorLoadingYourLeagues;

  /// Error checking daily limit message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao verificar limite diario. Tente novamente.'**
  String get errorCheckingDailyLimit;

  /// Error creating check-in message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao criar check-in. Tente novamente.'**
  String get errorCreatingCheckIn;

  /// Date at time format
  ///
  /// In pt, this message translates to:
  /// **'{day} de {month} de {year} as {time}'**
  String dateAt(int day, String month, int year, String time);

  /// January month name
  ///
  /// In pt, this message translates to:
  /// **'Janeiro'**
  String get monthJanuary;

  /// February month name
  ///
  /// In pt, this message translates to:
  /// **'Fevereiro'**
  String get monthFebruary;

  /// March month name
  ///
  /// In pt, this message translates to:
  /// **'Marco'**
  String get monthMarch;

  /// April month name
  ///
  /// In pt, this message translates to:
  /// **'Abril'**
  String get monthApril;

  /// May month name
  ///
  /// In pt, this message translates to:
  /// **'Maio'**
  String get monthMay;

  /// June month name
  ///
  /// In pt, this message translates to:
  /// **'Junho'**
  String get monthJune;

  /// July month name
  ///
  /// In pt, this message translates to:
  /// **'Julho'**
  String get monthJuly;

  /// August month name
  ///
  /// In pt, this message translates to:
  /// **'Agosto'**
  String get monthAugust;

  /// September month name
  ///
  /// In pt, this message translates to:
  /// **'Setembro'**
  String get monthSeptember;

  /// October month name
  ///
  /// In pt, this message translates to:
  /// **'Outubro'**
  String get monthOctober;

  /// November month name
  ///
  /// In pt, this message translates to:
  /// **'Novembro'**
  String get monthNovember;

  /// December month name
  ///
  /// In pt, this message translates to:
  /// **'Dezembro'**
  String get monthDecember;

  /// Week singular
  ///
  /// In pt, this message translates to:
  /// **'semana'**
  String get week;

  /// Weeks plural
  ///
  /// In pt, this message translates to:
  /// **'semanas'**
  String get weeks;

  /// Month singular
  ///
  /// In pt, this message translates to:
  /// **'mes'**
  String get monthSingular;

  /// Months plural
  ///
  /// In pt, this message translates to:
  /// **'meses'**
  String get monthsPlural;

  /// Year singular
  ///
  /// In pt, this message translates to:
  /// **'ano'**
  String get year;

  /// Years plural
  ///
  /// In pt, this message translates to:
  /// **'anos'**
  String get yearsPlural;

  /// Verify email page title
  ///
  /// In pt, this message translates to:
  /// **'Verificar e-mail'**
  String get verifyEmail;

  /// Verification email sent success message
  ///
  /// In pt, this message translates to:
  /// **'E-mail de verificacao enviado!'**
  String get verificationEmailSent;

  /// Verify your email title
  ///
  /// In pt, this message translates to:
  /// **'Verifique seu e-mail'**
  String get verifyYourEmail;

  /// Verification link sent to message
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um link de verificacao para:'**
  String get verificationLinkSentTo;

  /// Open email app instruction
  ///
  /// In pt, this message translates to:
  /// **'Abra seu aplicativo de e-mail'**
  String get openEmailApp;

  /// Look for BurgerRats email instruction
  ///
  /// In pt, this message translates to:
  /// **'Procure pelo e-mail do BurgerRats'**
  String get lookForBurgerRatsEmail;

  /// Click verification link instruction
  ///
  /// In pt, this message translates to:
  /// **'Clique no link de verificacao'**
  String get clickVerificationLink;

  /// Check spam folder hint
  ///
  /// In pt, this message translates to:
  /// **'Nao encontrou? Verifique tambem a pasta de spam.'**
  String get checkSpamFolder;

  /// Already verified button text
  ///
  /// In pt, this message translates to:
  /// **'Ja verifiquei'**
  String get alreadyVerified;

  /// Resend email button text
  ///
  /// In pt, this message translates to:
  /// **'Reenviar e-mail'**
  String get resendEmail;

  /// Resend in seconds button text
  ///
  /// In pt, this message translates to:
  /// **'Reenviar em {seconds}s'**
  String resendInSeconds(int seconds);

  /// Email not yet verified message
  ///
  /// In pt, this message translates to:
  /// **'E-mail ainda nao verificado'**
  String get emailNotYetVerified;

  /// Verifying automatically message
  ///
  /// In pt, this message translates to:
  /// **'Verificando automaticamente...'**
  String get verifyingAutomatically;

  /// No description provided for @clearAll.
  ///
  /// In pt, this message translates to:
  /// **'Limpar todos'**
  String get clearAll;

  /// No description provided for @memberSingular.
  ///
  /// In pt, this message translates to:
  /// **'membro'**
  String get memberSingular;

  /// No description provided for @membersPlural.
  ///
  /// In pt, this message translates to:
  /// **'membros'**
  String get membersPlural;

  /// Button text to remove selected photo
  ///
  /// In pt, this message translates to:
  /// **'Remover foto selecionada'**
  String get removeSelectedPhoto;

  /// Name field validation error
  ///
  /// In pt, this message translates to:
  /// **'Por favor, insira seu nome'**
  String get pleaseEnterName;

  /// Name minimum characters validation error
  ///
  /// In pt, this message translates to:
  /// **'Nome deve ter pelo menos {min} caracteres'**
  String nameMustHaveMinChars(int min);

  /// Email field help text
  ///
  /// In pt, this message translates to:
  /// **'O email nao pode ser alterado'**
  String get emailCannotBeChanged;

  /// Profile updated success message
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado com sucesso!'**
  String get profileUpdatedSuccess;

  /// Error updating profile message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao atualizar perfil. Tente novamente.'**
  String get errorUpdatingProfile;

  /// Photo updated success message
  ///
  /// In pt, this message translates to:
  /// **'Foto atualizada com sucesso!'**
  String get photoUpdatedSuccess;

  /// Error updating profile photo message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao atualizar foto no perfil.'**
  String get errorUpdatingPhoto;

  /// Error uploading photo message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao enviar foto. Tente novamente.'**
  String get errorUploadingPhoto;

  /// Error selecting photo message
  ///
  /// In pt, this message translates to:
  /// **'Erro ao selecionar foto: {error}'**
  String errorSelectingPhoto(String error);

  /// OK button text
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// Critical error dialog title
  ///
  /// In pt, this message translates to:
  /// **'Erro Critico'**
  String get criticalError;

  /// Contact support message
  ///
  /// In pt, this message translates to:
  /// **'Por favor, entre em contato com o suporte se o problema persistir.'**
  String get contactSupportIfPersists;

  /// No internet connection message
  ///
  /// In pt, this message translates to:
  /// **'Sem conexao com a internet'**
  String get noInternetConnection;

  /// No data found empty state message
  ///
  /// In pt, this message translates to:
  /// **'Nenhum dado encontrado'**
  String get noDataFound;

  /// Camera access card title
  ///
  /// In pt, this message translates to:
  /// **'Acesso a Camera'**
  String get cameraAccess;

  /// Camera access required screen title
  ///
  /// In pt, this message translates to:
  /// **'Acesso a Camera Necessario'**
  String get cameraAccessRequired;

  /// Camera permission title
  ///
  /// In pt, this message translates to:
  /// **'Permissao de Camera'**
  String get cameraPermission;

  /// Camera permission denied title
  ///
  /// In pt, this message translates to:
  /// **'Permissao de Camera Negada'**
  String get cameraPermissionDenied;

  /// Camera permission explanation text
  ///
  /// In pt, this message translates to:
  /// **'Precisamos de acesso a sua camera para tirar fotos dos seus check-ins. Suas fotos ajudam a verificar suas visitas e tornam a experiencia mais divertida!'**
  String get cameraPermissionExplanation;

  /// Camera permission denied explanation
  ///
  /// In pt, this message translates to:
  /// **'A permissao de camera foi negada. Para usar esta funcionalidade, voce precisa habilitar o acesso nas configuracoes do seu dispositivo.'**
  String get cameraPermissionDeniedExplanation;

  /// Camera permission permanently denied explanation
  ///
  /// In pt, this message translates to:
  /// **'Voce negou permanentemente o acesso a camera. Para usar esta funcionalidade, voce precisa habilitar a permissao nas configuracoes do seu dispositivo.'**
  String get cameraPermissionPermanentlyDeniedExplanation;

  /// Camera permission for check-ins explanation
  ///
  /// In pt, this message translates to:
  /// **'Para fazer check-ins com fotos, precisamos de acesso a camera do seu dispositivo.\n\nSuas fotos ajudam a verificar suas visitas e tornam a experiencia mais interativa e divertida!'**
  String get cameraPermissionForCheckIns;

  /// Allow access button text
  ///
  /// In pt, this message translates to:
  /// **'Permitir Acesso'**
  String get allowAccess;

  /// Allow camera access button text
  ///
  /// In pt, this message translates to:
  /// **'Permitir Acesso a Camera'**
  String get allowCameraAccess;

  /// Open settings button text
  ///
  /// In pt, this message translates to:
  /// **'Abrir Configuracoes'**
  String get openSettings;

  /// Not now button text
  ///
  /// In pt, this message translates to:
  /// **'Agora nao'**
  String get notNow;

  /// Camera feature: take check-in photos
  ///
  /// In pt, this message translates to:
  /// **'Tire fotos dos seus check-ins'**
  String get takeCheckInPhotos;

  /// Camera feature: verify visits
  ///
  /// In pt, this message translates to:
  /// **'Verifique suas visitas'**
  String get verifyYourVisits;

  /// Camera feature: share with friends
  ///
  /// In pt, this message translates to:
  /// **'Compartilhe com amigos'**
  String get shareWithFriends;

  /// Empty gallery title
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma foto ainda'**
  String get noPhotosYet;

  /// Empty gallery description
  ///
  /// In pt, this message translates to:
  /// **'Suas fotos de check-in aparecerao aqui'**
  String get checkInPhotosWillAppearHere;

  /// General notification channel name
  ///
  /// In pt, this message translates to:
  /// **'Geral'**
  String get notificationChannelGeneral;

  /// General notification channel description
  ///
  /// In pt, this message translates to:
  /// **'Notificacoes gerais do aplicativo'**
  String get notificationChannelGeneralDescription;

  /// Check-ins notification channel name
  ///
  /// In pt, this message translates to:
  /// **'Check-ins'**
  String get notificationChannelCheckIns;

  /// Check-ins notification channel description
  ///
  /// In pt, this message translates to:
  /// **'Notificacoes sobre novos check-ins na liga'**
  String get notificationChannelCheckInsDescription;

  /// Leagues notification channel name
  ///
  /// In pt, this message translates to:
  /// **'Ligas'**
  String get notificationChannelLeagues;

  /// Leagues notification channel description
  ///
  /// In pt, this message translates to:
  /// **'Notificacoes sobre convites e atualizacoes de ligas'**
  String get notificationChannelLeaguesDescription;

  /// Reminders notification channel name
  ///
  /// In pt, this message translates to:
  /// **'Lembretes'**
  String get notificationChannelReminders;

  /// Reminders notification channel description
  ///
  /// In pt, this message translates to:
  /// **'Lembretes para fazer check-in'**
  String get notificationChannelRemindersDescription;

  /// Reminder notification title
  ///
  /// In pt, this message translates to:
  /// **'Hora do check-in!'**
  String get notificationReminderTitle;

  /// Reminder notification body with league name
  ///
  /// In pt, this message translates to:
  /// **'Nao esqueca de fazer seu check-in na liga \"{leagueName}\"'**
  String notificationReminderBody(String leagueName);

  /// Check-in notification title
  ///
  /// In pt, this message translates to:
  /// **'{userName} fez check-in!'**
  String notificationCheckInTitle(String userName);

  /// Check-in notification body with restaurant and league
  ///
  /// In pt, this message translates to:
  /// **'{restaurantName} - {leagueName}'**
  String notificationCheckInBodyWithRestaurant(
    String restaurantName,
    String leagueName,
  );

  /// Check-in notification body without restaurant
  ///
  /// In pt, this message translates to:
  /// **'Novo check-in na liga {leagueName}'**
  String notificationCheckInBodyWithoutRestaurant(String leagueName);

  /// Reminder channel name for local notifications
  ///
  /// In pt, this message translates to:
  /// **'Lembretes de Check-in'**
  String get notificationReminderChannelName;

  /// Reminder channel description for local notifications
  ///
  /// In pt, this message translates to:
  /// **'Lembretes diarios para fazer check-in nas suas ligas'**
  String get notificationReminderChannelDescription;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
