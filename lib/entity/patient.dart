import 'package:floor/floor.dart';

// عنصر المريض
@entity
class Patient {
// يحتوي على

// رقم المريض وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;
// الاسم
  final String name;
// صوت الإشعار الهاص به
  final String tone;
// رقم تليفون الشخص المسؤول عنه
  final String phone;

  Patient(this.id, this.name, this.tone, this.phone);
}
