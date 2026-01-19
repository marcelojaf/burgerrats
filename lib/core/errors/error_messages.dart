/// Portuguese error messages for user-friendly display
class ErrorMessages {
  ErrorMessages._();

  // Generic messages
  static const String unknownError =
      'Ocorreu um erro inesperado. Por favor, tente novamente.';
  static const String tryAgainLater =
      'Algo deu errado. Por favor, tente novamente mais tarde.';

  // Network messages
  static const String noInternet =
      'Sem conexão com a internet. Verifique sua conexão e tente novamente.';
  static const String connectionTimeout =
      'A conexão expirou. Verifique sua internet e tente novamente.';
  static const String serverUnreachable =
      'Não foi possível conectar ao servidor. Tente novamente mais tarde.';

  // Server messages
  static const String serverError =
      'Erro no servidor. Por favor, tente novamente mais tarde.';
  static const String serviceUnavailable =
      'Serviço temporariamente indisponível. Tente novamente em alguns minutos.';
  static const String tooManyRequests =
      'Muitas tentativas. Por favor, aguarde um momento antes de tentar novamente.';

  // Authentication messages
  static const String invalidCredentials = 'E-mail ou senha incorretos.';
  static const String emailAlreadyInUse =
      'Este e-mail já está sendo usado por outra conta.';
  static const String weakPassword =
      'A senha é muito fraca. Use pelo menos 6 caracteres.';
  static const String userNotFound = 'Usuário não encontrado.';
  static const String wrongPassword = 'Senha incorreta.';
  static const String sessionExpired =
      'Sua sessão expirou. Por favor, faça login novamente.';
  static const String accountDisabled =
      'Esta conta foi desativada. Entre em contato com o suporte.';
  static const String emailNotVerified =
      'Por favor, verifique seu e-mail antes de continuar.';
  static const String invalidEmail = 'O e-mail informado não é válido.';

  // Permission messages
  static const String cameraPermissionDenied =
      'Permissão de câmera negada. Habilite nas configurações do dispositivo.';
  static const String locationPermissionDenied =
      'Permissão de localização negada. Habilite nas configurações do dispositivo.';
  static const String notificationPermissionDenied =
      'Permissão de notificações negada. Habilite nas configurações do dispositivo.';
  static const String storagePermissionDenied =
      'Permissão de armazenamento negada. Habilite nas configurações do dispositivo.';
  static const String permissionDenied =
      'Permissão negada. Habilite nas configurações do dispositivo.';

  // Camera/Photo capture messages
  static const String cameraCaptureFailed =
      'Não foi possível capturar a foto. Por favor, tente novamente.';
  static const String gallerySelectionFailed =
      'Não foi possível selecionar a foto. Por favor, tente novamente.';
  static const String cameraNotAvailable =
      'Câmera não disponível neste dispositivo.';
  static const String photoTooLarge =
      'A foto é muito grande. Por favor, tire uma foto com menor resolução.';

  // Image compression messages
  static const String compressionFailed =
      'Não foi possível comprimir a imagem. Por favor, tente novamente.';
  static const String invalidImageFormat =
      'Formato de imagem não suportado. Use JPG, PNG ou HEIC.';
  static const String imageFileNotFound =
      'Arquivo de imagem não encontrado.';
  static const String imageTooSmall =
      'A imagem é muito pequena para ser comprimida.';

  // Firestore messages
  static const String documentNotFound = 'Registro não encontrado.';
  static const String permissionDeniedFirestore =
      'Você não tem permissão para realizar esta ação.';
  static const String dataCorrupted =
      'Os dados estão corrompidos. Por favor, entre em contato com o suporte.';

  // Storage messages
  static const String uploadFailed =
      'Falha ao enviar arquivo. Por favor, tente novamente.';
  static const String downloadFailed =
      'Falha ao baixar arquivo. Por favor, tente novamente.';
  static const String fileTooLarge =
      'O arquivo é muito grande. O tamanho máximo é 10MB.';
  static const String invalidFileType =
      'Tipo de arquivo não suportado. Use JPG, PNG ou PDF.';

  // Cache messages
  static const String cacheReadError =
      'Erro ao ler dados locais. Tente novamente.';
  static const String cacheWriteError =
      'Erro ao salvar dados locais. Tente novamente.';
  static const String cacheExpired =
      'Os dados locais expiraram. Atualizando...';

  // Validation messages
  static const String requiredField = 'Este campo é obrigatório.';
  static const String invalidFormat = 'Formato inválido.';
  static const String minLength = 'Mínimo de caracteres não atingido.';
  static const String maxLength = 'Máximo de caracteres excedido.';
  static const String invalidCPF = 'CPF inválido.';
  static const String invalidPhone = 'Número de telefone inválido.';
  static const String passwordMismatch = 'As senhas não coincidem.';

  // Business logic messages (BurgerRats specific)
  static const String leagueNotFound = 'Liga não encontrada.';
  static const String alreadyCheckedInToday =
      'Você já fez check-in hoje nesta liga.';
  static const String notLeagueMember = 'Você não é membro desta liga.';
  static const String leagueFull = 'Esta liga já atingiu o número máximo de membros.';
  static const String inviteExpired = 'Este convite expirou.';
  static const String inviteAlreadyUsed = 'Este convite já foi utilizado.';
  static const String cannotLeaveAsOwner =
      'Você não pode sair da liga sendo o dono. Transfira a propriedade primeiro.';

  /// Maps error codes to user-friendly Portuguese messages
  static String getMessageForCode(String? code) {
    if (code == null) return unknownError;

    return switch (code) {
      // Firebase Auth error codes
      'invalid-email' => invalidEmail,
      'user-disabled' => accountDisabled,
      'user-not-found' => userNotFound,
      'wrong-password' => wrongPassword,
      'email-already-in-use' => emailAlreadyInUse,
      'weak-password' => weakPassword,
      'operation-not-allowed' => serverError,
      'too-many-requests' => tooManyRequests,
      'network-request-failed' => noInternet,
      'invalid-credential' => invalidCredentials,
      'requires-recent-login' => sessionExpired,

      // Firestore error codes
      'permission-denied' => permissionDeniedFirestore,
      'not-found' => documentNotFound,
      'already-exists' => 'Este registro já existe.',
      'resource-exhausted' => tooManyRequests,
      'failed-precondition' => 'Operação não permitida no estado atual.',
      'aborted' => 'Operação cancelada. Tente novamente.',
      'unavailable' => serviceUnavailable,
      'data-loss' => dataCorrupted,
      'unauthenticated' => sessionExpired,

      // Storage error codes
      'storage/unauthorized' => permissionDeniedFirestore,
      'storage/canceled' => 'Upload cancelado.',
      'storage/unknown' => uploadFailed,
      'storage/object-not-found' => 'Arquivo não encontrado.',
      'storage/quota-exceeded' => 'Limite de armazenamento excedido.',
      'storage/retry-limit-exceeded' => uploadFailed,

      // Network error codes
      'network-error' => noInternet,
      'timeout' => connectionTimeout,

      // Camera error codes
      'camera-capture-error' => cameraCaptureFailed,
      'gallery-selection-error' => gallerySelectionFailed,
      'camera-not-available' => cameraNotAvailable,
      'camera-permission-denied' => cameraPermissionDenied,
      'photo-too-large' => photoTooLarge,

      // Compression error codes
      'compression-failed' => compressionFailed,
      'invalid-image-format' => invalidImageFormat,
      'image-file-not-found' => imageFileNotFound,
      'image-too-small' => imageTooSmall,

      // Business error codes
      'league-not-found' => leagueNotFound,
      'already-checked-in' => alreadyCheckedInToday,
      'not-member' => notLeagueMember,
      'league-full' => leagueFull,
      'invite-expired' => inviteExpired,
      'invite-used' => inviteAlreadyUsed,
      'cannot-leave-as-owner' => cannotLeaveAsOwner,

      // Default
      _ => unknownError,
    };
  }
}
