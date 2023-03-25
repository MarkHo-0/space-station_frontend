import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../../../models/study_partner_post.dart';

class PartnerPostItem extends StatelessWidget {
  final StudyPartnerPost data;
  final Function()? onView;
  final Function()? onEdit;
  final Function()? onRemove;
  const PartnerPostItem(
    this.data, {
    this.onView,
    this.onEdit,
    this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).disabledColor),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Stack(
        children: [
          Visibility(
            visible: data.aimedGrade.gradeIndex > 0,
            child: buildAimedGradeBadge(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoPart(context),
                buildControlPart(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAimedGradeBadge(BuildContext context) {
    final gradeText = context.getString(
      'aim_grade_tag',
      {'s': data.aimedGrade.toString()},
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(3)),
        color: Theme.of(context).disabledColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        gradeText,
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildInfoPart(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.course.coureseName,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildControlPart(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: onEdit != null,
            child: ElevatedButton(
              onPressed: onEdit,
              child: Text(context.getString('edit_action')),
            ),
          ),
          Visibility(
            visible: onEdit != null && onRemove != null,
            child: const SizedBox(height: 5),
          ),
          Visibility(
            visible: onRemove != null,
            child: ElevatedButton(
              onPressed: onRemove,
              child: Text(context.getString('remove')),
            ),
          ),
          Visibility(
            visible: onView != null,
            child: ElevatedButton(
              onPressed: onView,
              child: Text(context.getString('view')),
            ),
          ),
        ],
      ),
    );
  }
}
