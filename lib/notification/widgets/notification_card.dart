import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stoyco_shared/core/gen/assets.gen.dart';
import 'package:stoyco_shared/notification/model/notification_model.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMoreOptions,
  });

  final NotificationModel notification;
  final void Function(NotificationModel) onTap;
  final void Function() onMoreOptions;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => onTap.call(notification),
          child: Container(
            height: 114,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: ShapeDecoration(
              color: notification.isReaded == false
                  ? const Color(0xFF202532)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: notification.isReaded == false
                  ? const [
                      BoxShadow(
                        color: Color(0xFF232336),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notification.materialColor,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      imageUrl: notification.image ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: constraints.maxHeight,
                        width: double.infinity,
                        color: Colors.white54,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    notification.text ?? '¡Tienes una nueva notificación!',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFF8F9FA),
                      fontSize: 14,
                      fontFamily: 'Akkurat Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _categorizeDate(
                            notification.createAt ?? DateTime.now(),
                          ),
                          maxLines: 3,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Color(0xFF92929D),
                            fontSize: 11,
                            fontFamily: 'Akkurat Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: onMoreOptions,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: SvgPicture.asset(
                            AssetsShared.home.horizontalDots.path,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  String _categorizeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'Ahora';
    } else if (difference.inHours < 24) {
      if (now.day != date.day) {
        return 'Hace 1 día';
      }
      final hoursLabel =
          Intl.plural(difference.inHours, other: 'horas', one: 'hora');
      return 'Hace ${difference.inHours} $hoursLabel';
    } else if (difference.inDays < 7) {
      final daysLabel =
          Intl.plural(difference.inDays, other: 'días', one: 'día');
      return 'Hace ${difference.inDays} $daysLabel';
    } else if (difference.inDays < 22) {
      final week = difference.inDays ~/ 7;
      final weeksLabel = Intl.plural(week, other: 'semanas', one: 'semana');
      return 'Hace $week $weeksLabel';
    } else {
      final month = difference.inDays ~/ 30;
      final monthsLabel = Intl.plural(month, other: 'meses', one: 'mes');
      return 'Hace $month $monthsLabel';
    }
  }
}
