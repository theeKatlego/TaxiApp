import 'package:flutter/material.dart';

@immutable
class User {
  const User({
    @required this.uid,
    @required this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}
