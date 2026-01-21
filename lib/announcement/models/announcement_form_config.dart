import 'dart:ui';

class AnnouncementParticipationViewConfig {
  const AnnouncementParticipationViewConfig({
    this.usernamePattern,
    this.urlPattern,
    this.textEndDate = 'End Date',
    this.textLeaderShip = 'Leadership Board',
    this.usernameRequiredMessage = 'Este campo es requerido',
    this.usernamePatternMessage = 'El nombre de usuario no es válido',
    this.urlRequiredMessage = 'Este campo es requerido',
    this.urlPatternMessage = 'La URL no es válida',
    this.buttonText = 'Participar',
    this.buttonFontWeight = FontWeight.bold,
    this.buttonTextNotLogged = 'Registrarse',
    this.termsText =
        'Al presionar enviar, aceptas los Términos de Servicio y confirmas haber leído y seguido las Directrices.',
    this.dialogTitle = 'Envia tu publicación',
    this.usernameLabel = 'Tiktok Username',
    this.usernameHint = '@',
    this.urlLabel = 'Post URL',
    this.urlHint = 'wwww',
    this.successDialog = const AnnouncementInfoBasicDialog(),
    this.errorDialog = const AnnouncementInfoBasicDialog(),
  });

  factory AnnouncementParticipationViewConfig.fromJson(
    Map<String, dynamic> json,
  ) =>
      AnnouncementParticipationViewConfig(
        textEndDate: json['textEndDate'] ?? 'End Date',
        textLeaderShip: json['textLeaderShip'] ?? 'Leadership Board',
        usernamePattern: json['usernamePattern'],
        urlPattern: json['urlPattern'],
        usernameRequiredMessage:
            json['usernameRequiredMessage'] ?? 'Este campo es requerido',
        usernamePatternMessage: json['usernamePatternMessage'] ??
            'El nombre de usuario no es válido',
        urlRequiredMessage:
            json['urlRequiredMessage'] ?? 'Este campo es requerido',
        urlPatternMessage: json['urlPatternMessage'] ?? 'La URL no es válida',
        buttonText: json['buttonText'] ?? 'Participar',
        buttonTextNotLogged: json['buttonTextNotLogged'] ?? 'Registrarse',
        termsText: json['termsText'] ??
            'Al presionar enviar, aceptas los Términos de Servicio y confirmas haber leído y seguido las Directrices.',
        dialogTitle: json['dialogTitle'] ?? 'Envia tu publicación',
        usernameLabel: json['usernameLabel'] ?? 'Tiktok Username',
        usernameHint: json['usernameHint'] ?? '@',
        urlLabel: json['urlLabel'] ?? 'Post Url',
        urlHint: json['urlHint'] ?? 'wwww',
        successDialog: json['successDialog'] != null
            ? AnnouncementInfoBasicDialog.fromJson(json['successDialog'])
            : const AnnouncementInfoBasicDialog(),
        errorDialog: json['errorDialog'] != null
            ? AnnouncementInfoBasicDialog.fromJson(json['errorDialog'])
            : const AnnouncementInfoBasicDialog(),
      );

  final String? usernamePattern;
  final String? urlPattern;
  final String usernameRequiredMessage;
  final String usernamePatternMessage;
  final String urlRequiredMessage;
  final String urlPatternMessage;
  final String buttonText;
  final FontWeight buttonFontWeight;
  final String buttonTextNotLogged;
  final String termsText;
  final String dialogTitle;
  final String usernameLabel;
  final String usernameHint;
  final String urlLabel;
  final String urlHint;
  final String textEndDate;
  final String textLeaderShip;
  final AnnouncementInfoBasicDialog successDialog;
  final AnnouncementInfoBasicDialog errorDialog;

  AnnouncementParticipationViewConfig copyWith({
    String? usernamePattern,
    String? urlPattern,
    String? usernameRequiredMessage,
    String? usernamePatternMessage,
    String? urlRequiredMessage,
    String? urlPatternMessage,
    String? buttonText,
    FontWeight? buttonFontWeight,
    String? buttonTextNotLogged,
    String? termsText,
    String? dialogTitle,
    String? usernameLabel,
    String? usernameHint,
    String? urlLabel,
    String? urlHint,
    String? textEndDate,
    String? textLeaderShip,
    AnnouncementInfoBasicDialog? successDialog,
    AnnouncementInfoBasicDialog? errorDialog,
  }) =>
      AnnouncementParticipationViewConfig(
        textEndDate: textEndDate ?? this.textEndDate,
        textLeaderShip: textLeaderShip ?? this.textLeaderShip,
        usernamePattern: usernamePattern ?? this.usernamePattern,
        urlPattern: urlPattern ?? this.urlPattern,
        usernameRequiredMessage:
            usernameRequiredMessage ?? this.usernameRequiredMessage,
        usernamePatternMessage:
            usernamePatternMessage ?? this.usernamePatternMessage,
        urlRequiredMessage: urlRequiredMessage ?? this.urlRequiredMessage,
        urlPatternMessage: urlPatternMessage ?? this.urlPatternMessage,
        buttonText: buttonText ?? this.buttonText,
        buttonFontWeight: buttonFontWeight ?? this.buttonFontWeight,
        buttonTextNotLogged: buttonTextNotLogged ?? this.buttonTextNotLogged,
        termsText: termsText ?? this.termsText,
        dialogTitle: dialogTitle ?? this.dialogTitle,
        usernameLabel: usernameLabel ?? this.usernameLabel,
        usernameHint: usernameHint ?? this.usernameHint,
        urlLabel: urlLabel ?? this.urlLabel,
        urlHint: urlHint ?? this.urlHint,
        successDialog: successDialog ?? this.successDialog,
        errorDialog: errorDialog ?? this.errorDialog,
      );
}

class AnnouncementInfoBasicDialog {
  const AnnouncementInfoBasicDialog({
    this.title = '',
    this.description = '',
    this.buttonText = '',
  });

  factory AnnouncementInfoBasicDialog.fromJson(Map<String, dynamic> json) =>
      AnnouncementInfoBasicDialog(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        buttonText: json['buttonText'] ?? '',
      );

  final String title;
  final String description;
  final String buttonText;

  AnnouncementInfoBasicDialog copyWith({
    String? title,
    String? description,
    String? buttonText,
  }) =>
      AnnouncementInfoBasicDialog(
        title: title ?? this.title,
        description: description ?? this.description,
        buttonText: buttonText ?? this.buttonText,
      );
}
