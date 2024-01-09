import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class StepInfo extends StatelessWidget {
  const StepInfo({
    super.key,
    this.descriptionWidth,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  final double? descriptionWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      width: descriptionWidth,
      child: Column(
        children: [
          StepTitleWidget(
            title: title,
          ),
          const Gap(38),
          StepDescription(
            description: description,
          ),
        ],
      ),
    );
  }
}

class StepTitleWidget extends StatelessWidget {
  final String title;
  const StepTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFFF2F2FA),
        fontSize: 32,
        fontFamily: 'Akkurat Pro',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class StepDescription extends StatelessWidget {
  final String description;
  const StepDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 452,
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF2F2FA),
          fontSize: 16,
          fontFamily: 'Akkurat Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
