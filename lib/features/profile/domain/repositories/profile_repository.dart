import 'package:dartz/dartz.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import 'package:bnu_lms_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
}
