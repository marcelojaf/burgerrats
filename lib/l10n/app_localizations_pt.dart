// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'BurgerRats';

  @override
  String get welcome => 'Bem-vindo';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get register => 'Cadastrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get home => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuracoes';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get loginSubtitle => 'Entre para avaliar hamburguerias';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get or => 'ou';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get registerSubtitle =>
      'Crie sua conta para comecar a avaliar hamburguerias e competir com seus amigos!';

  @override
  String get name => 'Nome';

  @override
  String get nameHint => 'Seu nome';

  @override
  String get passwordMinChars => 'Minimo 6 caracteres';

  @override
  String get acceptTermsText => 'Li e aceito os ';

  @override
  String get termsOfUse => 'Termos de Uso';

  @override
  String get and => ' e a ';

  @override
  String get privacyPolicy => 'Politica de Privacidade';

  @override
  String get mustAcceptTerms => 'Voce deve aceitar os termos de uso';

  @override
  String get alreadyHaveAccount => 'Ja tem uma conta?';

  @override
  String get recoverPassword => 'Recuperar senha';

  @override
  String get forgotPasswordTitle => 'Esqueceu sua senha?';

  @override
  String get forgotPasswordDescription =>
      'Digite seu e-mail e enviaremos um link para voce redefinir sua senha.';

  @override
  String get sendLink => 'Enviar link';

  @override
  String get backToLogin => 'Voltar para login';

  @override
  String get emailSent => 'E-mail enviado!';

  @override
  String get recoveryLinkSentTo => 'Enviamos um link de recuperacao para:';

  @override
  String get checkInboxAndSpam =>
      'Verifique sua caixa de entrada e a pasta de spam.';

  @override
  String get didNotReceiveResend => 'Nao recebeu? Enviar novamente';

  @override
  String get myLeagues => 'Minhas Ligas';

  @override
  String get joinLeague => 'Entrar em uma liga';

  @override
  String get newLeague => 'Nova Liga';

  @override
  String get member => 'membro';

  @override
  String get members => 'membros';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String minutesAgo(int minutes) {
    return 'Ha $minutes min';
  }

  @override
  String hoursAgo(int hours) {
    return 'Ha ${hours}h';
  }

  @override
  String get yesterday => 'Ontem';

  @override
  String daysAgo(int days) {
    return 'Ha $days dias';
  }

  @override
  String weekAgo(int weeks) {
    return 'Ha $weeks semana';
  }

  @override
  String weeksAgo(int weeks) {
    return 'Ha $weeks semanas';
  }

  @override
  String monthAgo(int months) {
    return 'Ha $months mes';
  }

  @override
  String monthsAgo(int months) {
    return 'Ha $months meses';
  }

  @override
  String yearAgo(int years) {
    return 'Ha $years ano';
  }

  @override
  String yearsAgo(int years) {
    return 'Ha $years anos';
  }

  @override
  String get noLeaguesYet => 'Nenhuma liga ainda';

  @override
  String get createOrJoinLeague =>
      'Crie uma nova liga ou entre em uma existente usando um codigo de convite.';

  @override
  String get join => 'Entrar';

  @override
  String get createLeague => 'Criar Liga';

  @override
  String get errorLoadingLeagues => 'Erro ao carregar ligas';

  @override
  String get checkConnectionTryAgain =>
      'Verifique sua conexao e tente novamente.';

  @override
  String get myCheckIns => 'Meus Check-ins';

  @override
  String get viewAsGallery => 'Ver como galeria';

  @override
  String get viewAsList => 'Ver como lista';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get filter => 'Filtrar';

  @override
  String get noCheckInsFound => 'Nenhum check-in encontrado';

  @override
  String get noCheckInsYet => 'Nenhum check-in ainda';

  @override
  String get adjustFiltersMessage =>
      'Tente ajustar os filtros para ver mais resultados.';

  @override
  String get makeFirstCheckIn =>
      'Faca seu primeiro check-in clicando no botao +';

  @override
  String get errorLoadingCheckIns => 'Erro ao carregar check-ins';

  @override
  String get filters => 'Filtros';

  @override
  String get clear => 'Limpar';

  @override
  String get league => 'Liga';

  @override
  String get notPartOfAnyLeague => 'Voce ainda nao faz parte de nenhuma liga.';

  @override
  String get allLeagues => 'Todas as ligas';

  @override
  String get period => 'Periodo';

  @override
  String get today => 'Hoje';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get last30Days => 'Ultimos 30 dias';

  @override
  String get startDate => 'Data inicial';

  @override
  String get endDate => 'Data final';

  @override
  String get clearPeriod => 'Limpar periodo';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get errorLoadingProfile => 'Erro ao carregar perfil';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get streak => 'Streak';

  @override
  String get leagues => 'Ligas';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get checkInHistory => 'Historico de Check-ins';

  @override
  String get logoutConfirmation => 'Tem certeza que deseja sair?';

  @override
  String get notifications => 'Notificacoes';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get portuguese => 'Portugues';

  @override
  String get english => 'Ingles';

  @override
  String get about => 'Sobre';

  @override
  String version(String version) {
    return 'Versao $version';
  }

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get deleteAccountConfirmation =>
      'Tem certeza que deseja excluir sua conta? Esta acao nao pode ser desfeita.';

  @override
  String get selectTheme => 'Selecionar Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get system => 'Sistema';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get skip => 'Pular';

  @override
  String get next => 'Proximo';

  @override
  String get start => 'Comecar';

  @override
  String get onboardingTitle1 => 'Bem-vindo ao BurgerRats!';

  @override
  String get onboardingDescription1 =>
      'Registre suas visitas a hamburguerias, avalie seus burgers favoritos e compartilhe suas experiencias com amigos.';

  @override
  String get onboardingHighlight1 => 'Sua jornada burger comeca aqui!';

  @override
  String get onboardingTitle2 => 'Compita em Ligas';

  @override
  String get onboardingDescription2 =>
      'Crie ou participe de ligas com seus amigos. Quem visitar mais hamburguerias no periodo da liga, ganha!';

  @override
  String get onboardingHighlight2 => 'Forme sua equipe e suba no ranking!';

  @override
  String get onboardingTitle3 => 'Faca Check-ins';

  @override
  String get onboardingDescription3 =>
      'Tire uma foto do seu burger, avalie de 1 a 5 estrelas e registre o nome da hamburgueria. Cada check-in vale pontos na liga!';

  @override
  String get onboardingHighlight3 => 'Um check-in por dia por liga!';

  @override
  String get mustBeLoggedIn => 'Voce precisa estar logado para criar uma liga';

  @override
  String get createYourLeague => 'Crie sua liga';

  @override
  String get createLeagueDescription =>
      'Reuna seus amigos e compitam para encontrar os melhores hamburgueres!';

  @override
  String get leagueName => 'Nome da Liga';

  @override
  String get leagueNameRequired => 'Nome da liga e obrigatorio';

  @override
  String get leagueNameHint => 'Ex: Burguer Hunters';

  @override
  String minCharsRequired(int min) {
    return 'Minimo de $min caracteres';
  }

  @override
  String get descriptionOptional => 'Descricao (opcional)';

  @override
  String get describeYourLeague => 'Descreva sua liga...';

  @override
  String get configuration => 'Configuracoes';

  @override
  String get publicLeague => 'Liga Publica';

  @override
  String get anyoneCanFind => 'Qualquer um pode encontrar sua liga';

  @override
  String get inviteCodeOnly => 'Apenas com codigo de convite';

  @override
  String get membersCanInvite => 'Membros podem convidar';

  @override
  String get allMembersCanShare => 'Todos membros podem compartilhar o codigo';

  @override
  String get onlyAdminsCanInvite => 'Apenas administradores podem convidar';

  @override
  String get maxMembers => 'Maximo de membros';

  @override
  String fromToMembers(int min, int max) {
    return 'De $min a $max membros';
  }

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get creating => 'Criando...';

  @override
  String get leagueCreated => 'Liga Criada!';

  @override
  String leagueCreatedSuccess(String name) {
    return 'Sua liga \"$name\" foi criada com sucesso!';
  }

  @override
  String get inviteCode => 'Codigo de Convite';

  @override
  String get codeCopied => 'Codigo copiado!';

  @override
  String get tapToCopy => 'Toque para copiar';

  @override
  String get shareInviteCode =>
      'Compartilhe este codigo com seus amigos para que eles possam entrar na sua liga!';

  @override
  String get back => 'Voltar';

  @override
  String get viewLeague => 'Ver Liga';

  @override
  String get requiredField => 'Este campo e obrigatorio.';

  @override
  String get invalidEmail => 'O e-mail informado nao e valido.';

  @override
  String get weakPassword =>
      'A senha e muito fraca. Use pelo menos 6 caracteres.';

  @override
  String get passwordMismatch => 'As senhas nao coincidem.';

  @override
  String get maxLengthExceeded => 'Maximo de caracteres excedido.';

  @override
  String get leagueDetails => 'Detalhes da Liga';

  @override
  String get shareInvite => 'Compartilhar Convite';

  @override
  String get leagueNotFound => 'Liga nao encontrada';

  @override
  String get leagueNotFoundDescription =>
      'A liga pode ter sido excluida ou voce nao tem acesso.';

  @override
  String get errorLoadingLeague => 'Erro ao carregar liga';

  @override
  String get promoteToAdmin => 'Promover a Admin';

  @override
  String get removeAdmin => 'Remover Admin';

  @override
  String get removeFromLeague => 'Remover da Liga';

  @override
  String get transferOwnership => 'Transferir Propriedade';

  @override
  String promoteToAdminConfirmation(String name) {
    return 'Deseja promover $name a admin? Admins podem gerenciar membros da liga.';
  }

  @override
  String get promote => 'Promover';

  @override
  String get promotingMember => 'Promovendo membro...';

  @override
  String removeAdminConfirmation(String name) {
    return 'Deseja remover $name como admin? Ele permanecera como membro da liga.';
  }

  @override
  String get removingAdmin => 'Removendo admin...';

  @override
  String get removeMember => 'Remover Membro';

  @override
  String removeMemberConfirmation(String name) {
    return 'Deseja remover $name da liga? Esta acao nao pode ser desfeita.';
  }

  @override
  String get remove => 'Remover';

  @override
  String get removingMember => 'Removendo membro...';

  @override
  String get cannotLeaveTitle => 'Nao e possivel sair';

  @override
  String get cannotLeaveOnlyMember =>
      'Voce e o unico membro da liga. Para sair, voce precisa excluir a liga.';

  @override
  String get understood => 'Entendi';

  @override
  String get cannotLeaveOwner =>
      'Voce e o dono da liga. Para sair, voce precisa excluir a liga ou transferir a propriedade para outro membro.';

  @override
  String get leaveLeague => 'Sair da Liga';

  @override
  String get leaveLeagueConfirmation =>
      'Deseja sair desta liga? Seus pontos serao perdidos e esta acao nao pode ser desfeita.';

  @override
  String get leave => 'Sair';

  @override
  String get leavingLeague => 'Saindo da liga...';

  @override
  String get selectNewOwner => 'Selecione o novo dono da liga:';

  @override
  String get confirmTransfer => 'Confirmar Transferencia';

  @override
  String transferOwnershipConfirmation(String name) {
    return 'Deseja transferir a propriedade da liga para $name?\n\nVoce se tornara um admin da liga.';
  }

  @override
  String get transfer => 'Transferir';

  @override
  String get transferringOwnership => 'Transferindo propriedade...';

  @override
  String get leagueSettings => 'Configuracoes da Liga';

  @override
  String get visibleToAllUsers => 'Visivel para todos os usuarios';

  @override
  String get pointsPerCheckIn => 'Pontos por Check-in';

  @override
  String get pointsPerReview => 'Pontos por Review';

  @override
  String get allowsMemberInvites =>
      'Permite que membros compartilhem o convite';

  @override
  String get requiresApproval => 'Requer aprovacao';

  @override
  String get newMembersNeedApproval => 'Novos membros precisam de aprovacao';

  @override
  String get savingSettings => 'Salvando configuracoes...';

  @override
  String get deleteLeague => 'Excluir Liga';

  @override
  String get deleteLeagueConfirmation =>
      'Deseja excluir esta liga permanentemente? Todos os membros serao removidos e esta acao nao pode ser desfeita.';

  @override
  String get deletingLeague => 'Excluindo liga...';

  @override
  String get generateNewCode => 'Gerar Novo Codigo';

  @override
  String get generateNewCodeConfirmation =>
      'Deseja gerar um novo codigo de convite? O codigo antigo sera invalidado.';

  @override
  String get generate => 'Gerar';

  @override
  String get generatingNewCode => 'Gerando novo codigo...';

  @override
  String get roleOwner => 'Dono';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Membro';

  @override
  String get publicLabel => 'Publica';

  @override
  String get privateLabel => 'Privada';

  @override
  String membersCount(int count, int max) {
    return '$count/$max membros';
  }

  @override
  String createdOn(String date) {
    return 'Criada em $date';
  }

  @override
  String get statistics => 'Estatisticas';

  @override
  String get totalPoints => 'Total de Pontos';

  @override
  String get averagePerMember => 'Media por Membro';

  @override
  String get ranking => 'Ranking';

  @override
  String get noMembersYet => 'Nenhum membro ainda';

  @override
  String get makeCheckInsForPoints => 'Faca check-ins para ganhar pontos!';

  @override
  String get tied => 'Empatado';

  @override
  String get loadingRanking => 'Carregando ranking...';

  @override
  String get errorLoadingRanking => 'Erro ao carregar ranking';

  @override
  String get reminders => 'Lembretes';

  @override
  String get copy => 'Copiar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Nao';

  @override
  String errorMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get joinLeagueTitle => 'Entrar em Liga';

  @override
  String get enterInviteCode => 'Digite o codigo de convite';

  @override
  String get askAdminForCode =>
      'Peca ao administrador da liga o codigo de 8 caracteres';

  @override
  String get enterInviteCodeValidation => 'Insira o codigo de convite';

  @override
  String get codeMustHaveChars => 'O codigo deve ter 8 caracteres';

  @override
  String get searching => 'Buscando...';

  @override
  String get searchLeague => 'Buscar Liga';

  @override
  String get visibility => 'Visibilidade';

  @override
  String get youJoined => 'Voce entrou!';

  @override
  String get joining => 'Entrando...';

  @override
  String get joinTheLeague => 'Entrar na Liga';

  @override
  String get mustBeLoggedInToJoin =>
      'Voce precisa estar logado para entrar em uma liga';

  @override
  String joinedLeagueSuccess(String name) {
    return 'Voce entrou na liga \"$name\" com sucesso!';
  }

  @override
  String get basicInfo => 'Informacoes Basicas';

  @override
  String get leagueNameLabel => 'Nome da Liga';

  @override
  String get enterLeagueName => 'Digite o nome da liga';

  @override
  String get leagueNameRequiredValidation => 'O nome da liga e obrigatorio';

  @override
  String get nameMustHaveChars => 'O nome deve ter pelo menos 3 caracteres';

  @override
  String get description => 'Descricao';

  @override
  String get enterDescriptionOptional => 'Digite uma descricao (opcional)';

  @override
  String get noPermission => 'Sem permissao';

  @override
  String get onlyAdminsCanAccessSettings =>
      'Apenas administradores podem acessar as configuracoes da liga.';

  @override
  String get errorLoadingSettings => 'Erro ao carregar configuracoes';

  @override
  String get savingChanges => 'Salvando alteracoes...';

  @override
  String get changesSavedSuccess => 'Alteracoes salvas com sucesso!';

  @override
  String get saveChanges => 'Salvar Alteracoes';

  @override
  String get discardChanges => 'Descartar alteracoes?';

  @override
  String get unsavedChangesWarning =>
      'Voce tem alteracoes nao salvas. Deseja descarta-las?';

  @override
  String get continueEditing => 'Continuar Editando';

  @override
  String get discard => 'Descartar';

  @override
  String get youLabel => '(voce)';

  @override
  String shareLeagueInviteMessage(String name, String link, String code) {
    return 'Junte-se a minha liga \"$name\" no BurgerRats! $link\n\nCodigo de convite: $code';
  }

  @override
  String leagueInviteSubject(String name) {
    return 'Convite para Liga - $name';
  }

  @override
  String get checkInDetails => 'Detalhes do Check-in';

  @override
  String get share => 'Compartilhar';

  @override
  String get generatingShareableImage => 'Gerando imagem compartilhavel...';

  @override
  String get note => 'Nota';

  @override
  String get details => 'Detalhes';

  @override
  String get checkInNotFound => 'Check-in nao encontrado';

  @override
  String get checkInNotFoundDescription =>
      'Este check-in pode ter sido removido ou o link esta incorreto.';

  @override
  String get errorLoadingCheckIn => 'Erro ao carregar check-in';

  @override
  String get newCheckIn => 'Novo Check-in';

  @override
  String get selectLeague => 'Selecione a Liga';

  @override
  String get detailsOptional => 'Detalhes (opcional)';

  @override
  String get restaurantName => 'Nome do Restaurante';

  @override
  String get restaurantNameHint => 'Ex: Burger King';

  @override
  String get observation => 'Observacao';

  @override
  String get observationHint => 'Conte sobre sua experiencia...';

  @override
  String get processing => 'Processando...';

  @override
  String get makeCheckIn => 'Fazer Check-in';

  @override
  String cannotCheckIn(String message) {
    return 'Nao e possivel fazer check-in: $message';
  }

  @override
  String get takePhotoToCheckIn =>
      'Tire uma foto do seu burger para fazer check-in';

  @override
  String get selectLeagueToCheckIn => 'Selecione uma liga para fazer check-in';

  @override
  String get joinALeague => 'Entrar em uma Liga';

  @override
  String get mustBeLoggedInToCheckIn =>
      'Voce precisa estar logado para fazer check-in.';

  @override
  String get checkInSuccess => 'Check-in realizado com sucesso!';

  @override
  String errorCapturingPhoto(String error) {
    return 'Erro ao capturar foto: $error';
  }

  @override
  String get takeBurgerPhoto => 'Tirar Foto do Burger';

  @override
  String get tapToAddPhoto => 'Toque para adicionar uma foto';

  @override
  String get availableForCheckIn => 'Disponivel para check-in';

  @override
  String get oneCheckInPerDayPerLeague =>
      'Voce pode fazer 1 check-in por dia nesta liga';

  @override
  String get dailyLimitReached => 'Limite diario atingido';

  @override
  String get alreadyCheckedInToday => 'Voce ja fez check-in hoje nesta liga.';

  @override
  String get changePhoto => 'Trocar';

  @override
  String get errorLoadingImage => 'Erro ao carregar imagem';

  @override
  String get photoAdded => 'Foto adicionada';

  @override
  String get ratingLabel => 'Avaliacao';

  @override
  String get tapStarsToRate => 'Toque nas estrelas para avaliar';

  @override
  String get ratingBad => 'Ruim';

  @override
  String get ratingRegular => 'Regular';

  @override
  String get ratingGood => 'Bom';

  @override
  String get ratingVeryGood => 'Muito bom';

  @override
  String get ratingExcellent => 'Excelente';

  @override
  String get compressingPhoto => 'Comprimindo foto...';

  @override
  String uploadingPhoto(int progress) {
    return 'Enviando foto ($progress%)...';
  }

  @override
  String get savingCheckIn => 'Salvando check-in...';

  @override
  String get updatingPoints => 'Atualizando pontos...';

  @override
  String get errorLoadingYourLeagues =>
      'Erro ao carregar suas ligas. Tente novamente.';

  @override
  String get errorCheckingDailyLimit =>
      'Erro ao verificar limite diario. Tente novamente.';

  @override
  String get errorCreatingCheckIn => 'Erro ao criar check-in. Tente novamente.';

  @override
  String dateAt(int day, String month, int year, String time) {
    return '$day de $month de $year as $time';
  }

  @override
  String get monthJanuary => 'Janeiro';

  @override
  String get monthFebruary => 'Fevereiro';

  @override
  String get monthMarch => 'Marco';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Maio';

  @override
  String get monthJune => 'Junho';

  @override
  String get monthJuly => 'Julho';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Setembro';

  @override
  String get monthOctober => 'Outubro';

  @override
  String get monthNovember => 'Novembro';

  @override
  String get monthDecember => 'Dezembro';

  @override
  String get week => 'semana';

  @override
  String get weeks => 'semanas';

  @override
  String get monthSingular => 'mes';

  @override
  String get monthsPlural => 'meses';

  @override
  String get year => 'ano';

  @override
  String get yearsPlural => 'anos';

  @override
  String get verifyEmail => 'Verificar e-mail';

  @override
  String get verificationEmailSent => 'E-mail de verificacao enviado!';

  @override
  String get verifyYourEmail => 'Verifique seu e-mail';

  @override
  String get verificationLinkSentTo => 'Enviamos um link de verificacao para:';

  @override
  String get openEmailApp => 'Abra seu aplicativo de e-mail';

  @override
  String get lookForBurgerRatsEmail => 'Procure pelo e-mail do BurgerRats';

  @override
  String get clickVerificationLink => 'Clique no link de verificacao';

  @override
  String get checkSpamFolder =>
      'Nao encontrou? Verifique tambem a pasta de spam.';

  @override
  String get alreadyVerified => 'Ja verifiquei';

  @override
  String get resendEmail => 'Reenviar e-mail';

  @override
  String resendInSeconds(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get emailNotYetVerified => 'E-mail ainda nao verificado';

  @override
  String get verifyingAutomatically => 'Verificando automaticamente...';

  @override
  String get clearAll => 'Limpar todos';

  @override
  String get memberSingular => 'membro';

  @override
  String get membersPlural => 'membros';

  @override
  String get removeSelectedPhoto => 'Remover foto selecionada';

  @override
  String get pleaseEnterName => 'Por favor, insira seu nome';

  @override
  String nameMustHaveMinChars(int min) {
    return 'Nome deve ter pelo menos $min caracteres';
  }

  @override
  String get emailCannotBeChanged => 'O email nao pode ser alterado';

  @override
  String get profileUpdatedSuccess => 'Perfil atualizado com sucesso!';

  @override
  String get errorUpdatingProfile =>
      'Erro ao atualizar perfil. Tente novamente.';

  @override
  String get photoUpdatedSuccess => 'Foto atualizada com sucesso!';

  @override
  String get errorUpdatingPhoto => 'Erro ao atualizar foto no perfil.';

  @override
  String get errorUploadingPhoto => 'Erro ao enviar foto. Tente novamente.';

  @override
  String errorSelectingPhoto(String error) {
    return 'Erro ao selecionar foto: $error';
  }

  @override
  String get ok => 'OK';

  @override
  String get criticalError => 'Erro Critico';

  @override
  String get contactSupportIfPersists =>
      'Por favor, entre em contato com o suporte se o problema persistir.';

  @override
  String get noInternetConnection => 'Sem conexao com a internet';

  @override
  String get noDataFound => 'Nenhum dado encontrado';

  @override
  String get cameraAccess => 'Acesso a Camera';

  @override
  String get cameraAccessRequired => 'Acesso a Camera Necessario';

  @override
  String get cameraPermission => 'Permissao de Camera';

  @override
  String get cameraPermissionDenied => 'Permissao de Camera Negada';

  @override
  String get cameraPermissionExplanation =>
      'Precisamos de acesso a sua camera para tirar fotos dos seus check-ins. Suas fotos ajudam a verificar suas visitas e tornam a experiencia mais divertida!';

  @override
  String get cameraPermissionDeniedExplanation =>
      'A permissao de camera foi negada. Para usar esta funcionalidade, voce precisa habilitar o acesso nas configuracoes do seu dispositivo.';

  @override
  String get cameraPermissionPermanentlyDeniedExplanation =>
      'Voce negou permanentemente o acesso a camera. Para usar esta funcionalidade, voce precisa habilitar a permissao nas configuracoes do seu dispositivo.';

  @override
  String get cameraPermissionForCheckIns =>
      'Para fazer check-ins com fotos, precisamos de acesso a camera do seu dispositivo.\n\nSuas fotos ajudam a verificar suas visitas e tornam a experiencia mais interativa e divertida!';

  @override
  String get allowAccess => 'Permitir Acesso';

  @override
  String get allowCameraAccess => 'Permitir Acesso a Camera';

  @override
  String get openSettings => 'Abrir Configuracoes';

  @override
  String get notNow => 'Agora nao';

  @override
  String get takeCheckInPhotos => 'Tire fotos dos seus check-ins';

  @override
  String get verifyYourVisits => 'Verifique suas visitas';

  @override
  String get shareWithFriends => 'Compartilhe com amigos';

  @override
  String get noPhotosYet => 'Nenhuma foto ainda';

  @override
  String get checkInPhotosWillAppearHere =>
      'Suas fotos de check-in aparecerao aqui';

  @override
  String get notificationChannelGeneral => 'Geral';

  @override
  String get notificationChannelGeneralDescription =>
      'Notificacoes gerais do aplicativo';

  @override
  String get notificationChannelCheckIns => 'Check-ins';

  @override
  String get notificationChannelCheckInsDescription =>
      'Notificacoes sobre novos check-ins na liga';

  @override
  String get notificationChannelLeagues => 'Ligas';

  @override
  String get notificationChannelLeaguesDescription =>
      'Notificacoes sobre convites e atualizacoes de ligas';

  @override
  String get notificationChannelReminders => 'Lembretes';

  @override
  String get notificationChannelRemindersDescription =>
      'Lembretes para fazer check-in';

  @override
  String get notificationReminderTitle => 'Hora do check-in!';

  @override
  String notificationReminderBody(String leagueName) {
    return 'Nao esqueca de fazer seu check-in na liga \"$leagueName\"';
  }

  @override
  String notificationCheckInTitle(String userName) {
    return '$userName fez check-in!';
  }

  @override
  String notificationCheckInBodyWithRestaurant(
    String restaurantName,
    String leagueName,
  ) {
    return '$restaurantName - $leagueName';
  }

  @override
  String notificationCheckInBodyWithoutRestaurant(String leagueName) {
    return 'Novo check-in na liga $leagueName';
  }

  @override
  String get notificationReminderChannelName => 'Lembretes de Check-in';

  @override
  String get notificationReminderChannelDescription =>
      'Lembretes diarios para fazer check-in nas suas ligas';
}
