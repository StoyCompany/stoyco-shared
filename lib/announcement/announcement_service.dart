import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/utils/logger.dart';

class AnnouncementService {
  factory AnnouncementService({
    required FirebaseRemoteConfig remoteConfig,
  }) {
    // For testing, we'll return a new instance each time if instance is not null
    // This allows us to reset the singleton in tests
    if (_instance != null && remoteConfig != _instance!.remoteConfig) {
      return AnnouncementService._(remoteConfig: remoteConfig);
    }

    _instance ??= AnnouncementService._(remoteConfig: remoteConfig);
    return _instance!;
  }

  AnnouncementService._({required this.remoteConfig});

  static AnnouncementService? _instance;

  final FirebaseRemoteConfig remoteConfig;

  // Add a method to reset the instance for testing purposes
  static void resetInstance() {
    _instance = null;
  }

  static AnnouncementService getInstance({
    required FirebaseRemoteConfig remoteConfig,
  }) {
    _instance ??= AnnouncementService._(remoteConfig: remoteConfig);
    return _instance!;
  }

  bool hasActiveAnnouncement() {
    try {
      final bool enableAnnouncement =
          remoteConfig.getBool('enable_announcement');
      return enableAnnouncement;
    } catch (e) {
      StoyCoLogger.error('Error checking active calls for applications: $e');
      return false;
    }
  }

  AnnouncementParticipationViewConfig getParticipationFormConfig() {
    try {
      final String json = remoteConfig.getValue('tiktok_config').asString();

      final Map<String, dynamic> jsonMap = jsonDecode(json);

      return AnnouncementParticipationViewConfig.fromJson(jsonMap);
    } catch (e) {
      StoyCoLogger.error('Error getting participation form config: $e');
      return const AnnouncementParticipationViewConfig();
    }
  }

  static Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String newId,
  ) async =>
      const Right(
        AnnouncementModel(
          id: '1',
          title: 'Vengo de la Nada Convocatoria Abierta',
          mainImage:
              'https://imagenes.elpais.com/resizer/v2/SGCDMUJIHFEOHCWYKY6HYSLA4Y.jpeg?auth=80111dc350afe9964bccbab59325c6f8299bac9308e0cb8ae159d4f733b03681&width=1960&height=1103&focal=1320%2C660',
          images: ['images'],
          content:
              '<p><strong style="color: rgb(230, 0, 0);">Conectividad Global: La Importancia de Internet para el Desarrollo Social 2024.</strong></p><p></p><p></p><p>En el siglo XXI, el acceso a internet se ha convertido en un elemento esencial para el desarrollo social y económico. Más allá de ser una herramienta tecnológica, es una puerta hacia oportunidades de educación, trabajo, comunicación y progreso, especialmente en comunidades marginadas.</p><p></p><p>La conectividad global permite <strong>reducir brechas sociales</strong>, proporcionando acceso a información y recursos que antes estaban fuera del alcance de muchos. Por ejemplo, estudiantes de zonas rurales pueden acceder a clases en línea, materiales educativos y bibliotecas virtuales, eliminando las barreras geográficas que antes limitaban su aprendizaje. Asimismo, emprendedores y pequeñas empresas pueden usar internet para llegar a mercados globales, lo que impulsa el crecimiento económico local.</p><p></p><p>Otro aspecto crucial es la <strong>promoción de la inclusión digital</strong>. A través de programas y políticas que buscan llevar internet a regiones desfavorecidas, millones de personas pueden participar en actividades sociales, culturales y económicas, fortaleciendo su integración en un mundo interconectado.</p><p></p><p>En términos de salud, internet facilita la telemedicina y el acceso a información vital sobre prevención y tratamiento de enfermedades. Las plataformas digitales también desempeñan un papel clave en la respuesta a emergencias y en la difusión de campañas de salud pública.</p><p></p><p>Sin embargo, aún existe una importante <strong>brecha digital</strong>. Según datos recientes, miles de millones de personas, especialmente en países en desarrollo, no tienen acceso a una conexión a internet confiable. Esto perpetúa desigualdades en educación, empleo y acceso a servicios básicos. Iniciativas como el despliegue de redes de bajo costo y la inversión en infraestructura tecnológica son esenciales para cerrar esta brecha.</p><p></p><p>La conectividad global no solo se trata de acceso, sino también de fomentar un <strong>uso responsable y seguro de internet</strong>. La alfabetización digital, la protección de datos y la lucha contra las noticias falsas son aspectos fundamentales para garantizar que la red sea una herramienta de empoderamiento y no un canal de desinformación o abuso.</p><p>En conclusión, internet es un pilar del desarrollo social moderno. Promueve igualdad de oportunidades, conecta a comunidades y facilita el progreso en múltiples ámbitos. Invertir en conectividad global es invertir en un futuro más justo y equitativo para todos.</p><p></p><p><img src="https://imagenesstoyco2.s3.amazonaws.com/conectividad-global%3A-la-importancia-de-internet745"></p>',
          shortDescription:
              'Prepárate para una noche llena de energía y poderosas guitarras con los Foo Fighters, interpretando lo mejor de su repertorio de rock alternativo. ¡Una fiesta que te hará vibrar con cada riff!',
          isDraft: false,
          isPublished: true,
          isDeleted: false,
          viewCount: 198,
          startDate: '2025-01-01T00:00:00Z',
          endDate: '2025-10-01T00:00:00Z',
          draftCreationDate: 'draftCreationDate',
          lastUpdatedDate: 'lastUpdatedDate',
          createdBy: 'JSRamirezDEV',
          createdAt: '2025-01-01T00:00:00Z',
        ),
      );

  static Future<Either<Failure, bool>> markAsViewed(String newId) async {
    throw UnimplementedError();
  }

  //getAnnouncementPaginated
  static Future<Either<Failure, List<AnnouncementModel>>>
      getAnnouncementPaginated(
    String newId,
    int pageSize,
  ) async {
    throw UnimplementedError();
  }

  //relatedAnnouncement
  static Future<Either<Failure, List<AnnouncementModel>>> relatedAnnouncement(
    String newId,
  ) async {
    throw UnimplementedError();
  }
}
