// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BurgerRats';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get loginSubtitle => 'Sign in to rate burger joints';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle =>
      'Create your account to start rating burger joints and compete with your friends!';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'Your name';

  @override
  String get passwordMinChars => 'Minimum 6 characters';

  @override
  String get acceptTermsText => 'I have read and accept the ';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get and => ' and the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get mustAcceptTerms => 'You must accept the terms of use';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get recoverPassword => 'Recover password';

  @override
  String get forgotPasswordTitle => 'Forgot your password?';

  @override
  String get forgotPasswordDescription =>
      'Enter your email and we will send you a link to reset your password.';

  @override
  String get sendLink => 'Send link';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get emailSent => 'Email sent!';

  @override
  String get recoveryLinkSentTo => 'We sent a recovery link to:';

  @override
  String get checkInboxAndSpam => 'Check your inbox and spam folder.';

  @override
  String get didNotReceiveResend => 'Didn\'t receive it? Resend';

  @override
  String get myLeagues => 'My Leagues';

  @override
  String get joinLeague => 'Join a league';

  @override
  String get newLeague => 'New League';

  @override
  String get member => 'member';

  @override
  String get members => 'members';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String weekAgo(int weeks) {
    return '$weeks week ago';
  }

  @override
  String weeksAgo(int weeks) {
    return '$weeks weeks ago';
  }

  @override
  String monthAgo(int months) {
    return '$months month ago';
  }

  @override
  String monthsAgo(int months) {
    return '$months months ago';
  }

  @override
  String yearAgo(int years) {
    return '$years year ago';
  }

  @override
  String yearsAgo(int years) {
    return '$years years ago';
  }

  @override
  String get noLeaguesYet => 'No leagues yet';

  @override
  String get createOrJoinLeague =>
      'Create a new league or join an existing one using an invite code.';

  @override
  String get join => 'Join';

  @override
  String get createLeague => 'Create League';

  @override
  String get errorLoadingLeagues => 'Error loading leagues';

  @override
  String get checkConnectionTryAgain => 'Check your connection and try again.';

  @override
  String get myCheckIns => 'My Check-ins';

  @override
  String get viewAsGallery => 'View as gallery';

  @override
  String get viewAsList => 'View as list';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get filter => 'Filter';

  @override
  String get noCheckInsFound => 'No check-ins found';

  @override
  String get noCheckInsYet => 'No check-ins yet';

  @override
  String get adjustFiltersMessage =>
      'Try adjusting the filters to see more results.';

  @override
  String get makeFirstCheckIn =>
      'Make your first check-in by tapping the + button';

  @override
  String get errorLoadingCheckIns => 'Error loading check-ins';

  @override
  String get filters => 'Filters';

  @override
  String get clear => 'Clear';

  @override
  String get league => 'League';

  @override
  String get notPartOfAnyLeague => 'You are not part of any league yet.';

  @override
  String get allLeagues => 'All leagues';

  @override
  String get period => 'Period';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get clearPeriod => 'Clear period';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get streak => 'Streak';

  @override
  String get leagues => 'Leagues';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get checkInHistory => 'Check-in History';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get onboardingTitle1 => 'Welcome to BurgerRats!';

  @override
  String get onboardingDescription1 =>
      'Record your visits to burger joints, rate your favorite burgers and share your experiences with friends.';

  @override
  String get onboardingHighlight1 => 'Your burger journey starts here!';

  @override
  String get onboardingTitle2 => 'Compete in Leagues';

  @override
  String get onboardingDescription2 =>
      'Create or join leagues with your friends. Whoever visits more burger joints during the league period wins!';

  @override
  String get onboardingHighlight2 => 'Form your team and climb the ranking!';

  @override
  String get onboardingTitle3 => 'Make Check-ins';

  @override
  String get onboardingDescription3 =>
      'Take a photo of your burger, rate it from 1 to 5 stars and record the burger joint name. Each check-in earns league points!';

  @override
  String get onboardingHighlight3 => 'One check-in per day per league!';

  @override
  String get mustBeLoggedIn => 'You must be logged in to create a league';

  @override
  String get createYourLeague => 'Create your league';

  @override
  String get createLeagueDescription =>
      'Gather your friends and compete to find the best burgers!';

  @override
  String get leagueName => 'League Name';

  @override
  String get leagueNameRequired => 'League name is required';

  @override
  String get leagueNameHint => 'E.g.: Burger Hunters';

  @override
  String minCharsRequired(int min) {
    return 'Minimum of $min characters';
  }

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get describeYourLeague => 'Describe your league...';

  @override
  String get configuration => 'Configuration';

  @override
  String get publicLeague => 'Public League';

  @override
  String get anyoneCanFind => 'Anyone can find your league';

  @override
  String get inviteCodeOnly => 'Invite code only';

  @override
  String get membersCanInvite => 'Members can invite';

  @override
  String get allMembersCanShare => 'All members can share the code';

  @override
  String get onlyAdminsCanInvite => 'Only admins can invite';

  @override
  String get maxMembers => 'Maximum members';

  @override
  String fromToMembers(int min, int max) {
    return 'From $min to $max members';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String get creating => 'Creating...';

  @override
  String get leagueCreated => 'League Created!';

  @override
  String leagueCreatedSuccess(String name) {
    return 'Your league \"$name\" was created successfully!';
  }

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get codeCopied => 'Code copied!';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get shareInviteCode =>
      'Share this code with your friends so they can join your league!';

  @override
  String get back => 'Back';

  @override
  String get viewLeague => 'View League';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get invalidEmail => 'The email address is not valid.';

  @override
  String get weakPassword =>
      'The password is too weak. Use at least 6 characters.';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get maxLengthExceeded => 'Maximum number of characters exceeded.';

  @override
  String get leagueDetails => 'League Details';

  @override
  String get shareInvite => 'Share Invite';

  @override
  String get leagueNotFound => 'League not found';

  @override
  String get leagueNotFoundDescription =>
      'The league may have been deleted or you don\'t have access.';

  @override
  String get errorLoadingLeague => 'Error loading league';

  @override
  String get promoteToAdmin => 'Promote to Admin';

  @override
  String get removeAdmin => 'Remove Admin';

  @override
  String get removeFromLeague => 'Remove from League';

  @override
  String get transferOwnership => 'Transfer Ownership';

  @override
  String promoteToAdminConfirmation(String name) {
    return 'Do you want to promote $name to admin? Admins can manage league members.';
  }

  @override
  String get promote => 'Promote';

  @override
  String get promotingMember => 'Promoting member...';

  @override
  String removeAdminConfirmation(String name) {
    return 'Do you want to remove $name as admin? They will remain as a league member.';
  }

  @override
  String get removingAdmin => 'Removing admin...';

  @override
  String get removeMember => 'Remove Member';

  @override
  String removeMemberConfirmation(String name) {
    return 'Do you want to remove $name from the league? This action cannot be undone.';
  }

  @override
  String get remove => 'Remove';

  @override
  String get removingMember => 'Removing member...';

  @override
  String get cannotLeaveTitle => 'Cannot leave';

  @override
  String get cannotLeaveOnlyMember =>
      'You are the only member of the league. To leave, you need to delete the league.';

  @override
  String get understood => 'Understood';

  @override
  String get cannotLeaveOwner =>
      'You are the owner of the league. To leave, you need to delete the league or transfer ownership to another member.';

  @override
  String get leaveLeague => 'Leave League';

  @override
  String get leaveLeagueConfirmation =>
      'Do you want to leave this league? Your points will be lost and this action cannot be undone.';

  @override
  String get leave => 'Leave';

  @override
  String get leavingLeague => 'Leaving league...';

  @override
  String get selectNewOwner => 'Select the new owner of the league:';

  @override
  String get confirmTransfer => 'Confirm Transfer';

  @override
  String transferOwnershipConfirmation(String name) {
    return 'Do you want to transfer ownership of the league to $name?\n\nYou will become an admin of the league.';
  }

  @override
  String get transfer => 'Transfer';

  @override
  String get transferringOwnership => 'Transferring ownership...';

  @override
  String get leagueSettings => 'League Settings';

  @override
  String get visibleToAllUsers => 'Visible to all users';

  @override
  String get pointsPerCheckIn => 'Points per Check-in';

  @override
  String get pointsPerReview => 'Points per Review';

  @override
  String get allowsMemberInvites => 'Allows members to share the invite';

  @override
  String get requiresApproval => 'Requires approval';

  @override
  String get newMembersNeedApproval => 'New members need approval';

  @override
  String get savingSettings => 'Saving settings...';

  @override
  String get deleteLeague => 'Delete League';

  @override
  String get deleteLeagueConfirmation =>
      'Do you want to permanently delete this league? All members will be removed and this action cannot be undone.';

  @override
  String get deletingLeague => 'Deleting league...';

  @override
  String get generateNewCode => 'Generate New Code';

  @override
  String get generateNewCodeConfirmation =>
      'Do you want to generate a new invite code? The old code will be invalidated.';

  @override
  String get generate => 'Generate';

  @override
  String get generatingNewCode => 'Generating new code...';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get publicLabel => 'Public';

  @override
  String get privateLabel => 'Private';

  @override
  String membersCount(int count, int max) {
    return '$count/$max members';
  }

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get averagePerMember => 'Average per Member';

  @override
  String get ranking => 'Ranking';

  @override
  String get noMembersYet => 'No members yet';

  @override
  String get makeCheckInsForPoints => 'Make check-ins to earn points!';

  @override
  String get tied => 'Tied';

  @override
  String get loadingRanking => 'Loading ranking...';

  @override
  String get errorLoadingRanking => 'Error loading ranking';

  @override
  String get reminders => 'Reminders';

  @override
  String get copy => 'Copy';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get joinLeagueTitle => 'Join League';

  @override
  String get enterInviteCode => 'Enter the invite code';

  @override
  String get askAdminForCode =>
      'Ask the league administrator for the invite code';

  @override
  String get enterInviteCodeValidation => 'Enter the invite code';

  @override
  String get codeMustHaveChars =>
      'The code must have between 6 and 8 characters';

  @override
  String get searching => 'Searching...';

  @override
  String get searchLeague => 'Search League';

  @override
  String get visibility => 'Visibility';

  @override
  String get youJoined => 'You joined!';

  @override
  String get joining => 'Joining...';

  @override
  String get joinTheLeague => 'Join the League';

  @override
  String get mustBeLoggedInToJoin => 'You must be logged in to join a league';

  @override
  String joinedLeagueSuccess(String name) {
    return 'You joined the league \"$name\" successfully!';
  }

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get leagueNameLabel => 'League Name';

  @override
  String get enterLeagueName => 'Enter the league name';

  @override
  String get leagueNameRequiredValidation => 'League name is required';

  @override
  String get nameMustHaveChars => 'Name must have at least 3 characters';

  @override
  String get description => 'Description';

  @override
  String get enterDescriptionOptional => 'Enter a description (optional)';

  @override
  String get noPermission => 'No permission';

  @override
  String get onlyAdminsCanAccessSettings =>
      'Only administrators can access league settings.';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get savingChanges => 'Saving changes...';

  @override
  String get changesSavedSuccess => 'Changes saved successfully!';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get discardChanges => 'Discard changes?';

  @override
  String get unsavedChangesWarning =>
      'You have unsaved changes. Do you want to discard them?';

  @override
  String get continueEditing => 'Continue Editing';

  @override
  String get discard => 'Discard';

  @override
  String get youLabel => '(you)';

  @override
  String shareLeagueInviteMessage(String name, String link, String code) {
    return 'Join my league \"$name\" on BurgerRats! $link\n\nInvite code: $code';
  }

  @override
  String leagueInviteSubject(String name) {
    return 'League Invite - $name';
  }

  @override
  String get checkInDetails => 'Check-in Details';

  @override
  String get share => 'Share';

  @override
  String get generatingShareableImage => 'Generating shareable image...';

  @override
  String get note => 'Note';

  @override
  String get details => 'Details';

  @override
  String get checkInNotFound => 'Check-in not found';

  @override
  String get checkInNotFoundDescription =>
      'This check-in may have been removed or the link is incorrect.';

  @override
  String get errorLoadingCheckIn => 'Error loading check-in';

  @override
  String get newCheckIn => 'New Check-in';

  @override
  String get selectLeague => 'Select League';

  @override
  String get detailsOptional => 'Details (optional)';

  @override
  String get restaurantName => 'Restaurant Name';

  @override
  String get restaurantNameHint => 'E.g.: Burger King';

  @override
  String get observation => 'Observation';

  @override
  String get observationHint => 'Tell about your experience...';

  @override
  String get processing => 'Processing...';

  @override
  String get makeCheckIn => 'Make Check-in';

  @override
  String cannotCheckIn(String message) {
    return 'Cannot check-in: $message';
  }

  @override
  String get takePhotoToCheckIn => 'Take a photo of your burger to check-in';

  @override
  String get selectLeagueToCheckIn => 'Select a league to check-in';

  @override
  String get joinALeague => 'Join a League';

  @override
  String get mustBeLoggedInToCheckIn => 'You must be logged in to check-in.';

  @override
  String get checkInSuccess => 'Check-in completed successfully!';

  @override
  String errorCapturingPhoto(String error) {
    return 'Error capturing photo: $error';
  }

  @override
  String get takeBurgerPhoto => 'Take Burger Photo';

  @override
  String get tapToAddPhoto => 'Tap to add a photo';

  @override
  String get availableForCheckIn => 'Available for check-in';

  @override
  String get oneCheckInPerDayPerLeague =>
      'You can make 1 check-in per day in this league';

  @override
  String get dailyLimitReached => 'Daily limit reached';

  @override
  String get alreadyCheckedInToday =>
      'You already checked in today in this league.';

  @override
  String get changePhoto => 'Change';

  @override
  String get errorLoadingImage => 'Error loading image';

  @override
  String get photoAdded => 'Photo added';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get tapStarsToRate => 'Tap the stars to rate';

  @override
  String get ratingBad => 'Bad';

  @override
  String get ratingRegular => 'Regular';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingVeryGood => 'Very good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get compressingPhoto => 'Compressing photo...';

  @override
  String uploadingPhoto(int progress) {
    return 'Uploading photo ($progress%)...';
  }

  @override
  String get savingCheckIn => 'Saving check-in...';

  @override
  String get updatingPoints => 'Updating points...';

  @override
  String get errorLoadingYourLeagues =>
      'Error loading your leagues. Try again.';

  @override
  String get errorCheckingDailyLimit =>
      'Error checking daily limit. Try again.';

  @override
  String get errorCreatingCheckIn => 'Error creating check-in. Try again.';

  @override
  String dateAt(int day, String month, int year, String time) {
    return '$day of $month of $year at $time';
  }

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get week => 'week';

  @override
  String get weeks => 'weeks';

  @override
  String get monthSingular => 'month';

  @override
  String get monthsPlural => 'months';

  @override
  String get year => 'year';

  @override
  String get yearsPlural => 'years';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get verificationEmailSent => 'Verification email sent!';

  @override
  String get verifyYourEmail => 'Verify your email';

  @override
  String get verificationLinkSentTo => 'We sent a verification link to:';

  @override
  String get openEmailApp => 'Open your email app';

  @override
  String get lookForBurgerRatsEmail => 'Look for the BurgerRats email';

  @override
  String get clickVerificationLink => 'Click the verification link';

  @override
  String get checkSpamFolder => 'Didn\'t find it? Also check your spam folder.';

  @override
  String get alreadyVerified => 'I\'ve verified';

  @override
  String get resendEmail => 'Resend email';

  @override
  String resendInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get emailNotYetVerified => 'Email not yet verified';

  @override
  String get verifyingAutomatically => 'Verifying automatically...';

  @override
  String get clearAll => 'Clear all';

  @override
  String get memberSingular => 'member';

  @override
  String get membersPlural => 'members';

  @override
  String get removeSelectedPhoto => 'Remove selected photo';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String nameMustHaveMinChars(int min) {
    return 'Name must have at least $min characters';
  }

  @override
  String get emailCannotBeChanged => 'Email cannot be changed';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get errorUpdatingProfile => 'Error updating profile. Try again.';

  @override
  String get photoUpdatedSuccess => 'Photo updated successfully!';

  @override
  String get errorUpdatingPhoto => 'Error updating profile photo.';

  @override
  String get errorUploadingPhoto => 'Error uploading photo. Try again.';

  @override
  String errorSelectingPhoto(String error) {
    return 'Error selecting photo: $error';
  }

  @override
  String get ok => 'OK';

  @override
  String get criticalError => 'Critical Error';

  @override
  String get contactSupportIfPersists =>
      'Please contact support if the problem persists.';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get noDataFound => 'No data found';

  @override
  String get cameraAccess => 'Camera Access';

  @override
  String get cameraAccessRequired => 'Camera Access Required';

  @override
  String get cameraPermission => 'Camera Permission';

  @override
  String get cameraPermissionDenied => 'Camera Permission Denied';

  @override
  String get cameraPermissionExplanation =>
      'We need access to your camera to take photos of your check-ins. Your photos help verify your visits and make the experience more fun!';

  @override
  String get cameraPermissionDeniedExplanation =>
      'Camera permission was denied. To use this feature, you need to enable access in your device settings.';

  @override
  String get cameraPermissionPermanentlyDeniedExplanation =>
      'You permanently denied camera access. To use this feature, you need to enable the permission in your device settings.';

  @override
  String get cameraPermissionForCheckIns =>
      'To make check-ins with photos, we need access to your device\'s camera.\n\nYour photos help verify your visits and make the experience more interactive and fun!';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get allowCameraAccess => 'Allow Camera Access';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get notNow => 'Not now';

  @override
  String get takeCheckInPhotos => 'Take photos of your check-ins';

  @override
  String get verifyYourVisits => 'Verify your visits';

  @override
  String get shareWithFriends => 'Share with friends';

  @override
  String get noPhotosYet => 'No photos yet';

  @override
  String get checkInPhotosWillAppearHere =>
      'Your check-in photos will appear here';

  @override
  String get notificationChannelGeneral => 'General';

  @override
  String get notificationChannelGeneralDescription =>
      'General app notifications';

  @override
  String get notificationChannelCheckIns => 'Check-ins';

  @override
  String get notificationChannelCheckInsDescription =>
      'Notifications about new check-ins in the league';

  @override
  String get notificationChannelLeagues => 'Leagues';

  @override
  String get notificationChannelLeaguesDescription =>
      'Notifications about league invites and updates';

  @override
  String get notificationChannelReminders => 'Reminders';

  @override
  String get notificationChannelRemindersDescription =>
      'Reminders to make check-ins';

  @override
  String get notificationReminderTitle => 'Time to check-in!';

  @override
  String notificationReminderBody(String leagueName) {
    return 'Don\'t forget to check-in at the \"$leagueName\" league';
  }

  @override
  String notificationCheckInTitle(String userName) {
    return '$userName checked in!';
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
    return 'New check-in at $leagueName league';
  }

  @override
  String get notificationReminderChannelName => 'Check-in Reminders';

  @override
  String get notificationReminderChannelDescription =>
      'Daily reminders to check-in at your leagues';
}
