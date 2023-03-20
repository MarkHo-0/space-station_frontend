import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/widgets.dart';

import 'methods/base.dart';
import 'methods/phone_number.dart';
import 'methods/platform_user_id.dart';
import 'methods/private_email.dart';
import 'methods/student_email.dart';

final kMethods = [
  ContactMethod('school_email', ContactStudentEmail()),
  ContactMethod('private_email', ContactPrivateEmail()),
  ContactMethod('whatsapp', ContactPhoneNumber()),
  ContactMethod('telegram', ContactPlatformUserID()),
  ContactMethod('signal', ContactPlatformUserID()),
  ContactMethod('wechat', ContactPlatformUserID()),
];

class ContactMethod {
  final String dataKey;
  final ContactDetail detail;
  const ContactMethod(this.dataKey, this.detail);
}

String getMetholdName(BuildContext context, int methodID) {
  final key = kMethods[methodID].dataKey;
  return context.getString('c_methold_$key');
}
