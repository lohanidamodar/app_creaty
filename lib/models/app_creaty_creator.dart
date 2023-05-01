import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_creaty_creator.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class AppCreatyCreator {
  AppCreatyCreator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppCreatyCreator.fromJson(Map<String, dynamic> json) =>
      _$AppCreatyCreatorFromJson(json);

  factory AppCreatyCreator.local() {
    return AppCreatyCreator(
      id: null,
      name: 'Localhost',
      email: null,
    );
  }
  
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? email;

  Map<String, dynamic> toJson() => _$AppCreatyCreatorToJson(this);
}