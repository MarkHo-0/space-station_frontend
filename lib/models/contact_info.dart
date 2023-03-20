import 'package:flutter/material.dart';
import 'package:space_station/providers/auth_provider.dart';

class ContactInfo {
  final int method;
  final String detail;

  ContactInfo(this.method, this.detail);

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      json['method'],
      json['detail'],
    );
  }

  factory ContactInfo.fromDefault(BuildContext context) {
    final user = getLoginedUser(context);
    if (user == null) return ContactInfo(2, '');
    return ContactInfo(1, user.sid.toString());
  }

  List<String> toStringList() {
    return [method.toString(), detail];
  }

  Map<String, dynamic> toJson() {
    return {'method': method, 'detail': detail};
  }
}
