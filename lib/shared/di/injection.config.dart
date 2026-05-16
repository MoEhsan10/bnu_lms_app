// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/assignments/data/data_sources/remote/assignment_remote_data_source.dart'
    as _i1042;
import '../../features/assignments/data/repositories/assignment_repository_impl.dart'
    as _i58;
import '../../features/assignments/domain/repositories/assignment_repository.dart'
    as _i928;
import '../../features/assignments/presentation/manager/instructor/assignments_cubit.dart'
    as _i407;
import '../../features/assignments/presentation/manager/instructor/grading_cubit.dart'
    as _i733;
import '../../features/assignments/presentation/manager/student/student_assignments_cubit.dart'
    as _i633;
import '../../features/assignments/presentation/manager/submission/assignment_submission_cubit.dart'
    as _i957;
import '../../features/auth/data/data_sources/remote/auth_remote_data_source.dart'
    as _i432;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/courses/data/data_sources/remote/course_remote_data_source.dart'
    as _i598;
import '../../features/courses/data/repositories/course_repository_impl.dart'
    as _i657;
import '../../features/courses/domain/repositories/course_repository.dart'
    as _i749;
import '../../features/courses/domain/use_cases/add_content_use_case.dart'
    as _i448;
import '../../features/courses/domain/use_cases/add_lesson_use_case.dart'
    as _i113;
import '../../features/courses/domain/use_cases/create_module_use_case.dart'
    as _i865;
import '../../features/courses/domain/use_cases/get_assigned_courses_use_case.dart'
    as _i26;
import '../../features/courses/domain/use_cases/get_course_details_use_case.dart'
    as _i1055;
import '../../features/courses/domain/use_cases/get_enrolled_courses_use_case.dart'
    as _i773;
import '../../features/courses/presentation/cubit/course_details_cubit/course_details_cubit.dart'
    as _i445;
import '../../features/courses/presentation/cubit/courses_cubit/courses_cubit.dart'
    as _i382;
import '../../features/profile/data/data_sources/remote/profile_remote_data_source.dart'
    as _i683;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/get_my_profile_use_case.dart'
    as _i763;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../services/signalr_service.dart' as _i320;
import 'dio_module.dart' as _i1045;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i320.SignalRService>(() => _i320.SignalRService());
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => dioModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i432.AuthRemoteDataSource>(
      () => _i432.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i432.AuthRemoteDataSource>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i1042.AssignmentRemoteDataSource>(
      () => _i1042.AssignmentRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i698.LogoutUseCase>(
      () => _i698.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i928.AssignmentRepository>(
      () => _i58.AssignmentRepositoryImpl(
        gh<_i1042.AssignmentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i733.GradingCubit>(
      () => _i733.GradingCubit(gh<_i928.AssignmentRepository>()),
    );
    gh.factory<_i957.AssignmentSubmissionCubit>(
      () => _i957.AssignmentSubmissionCubit(gh<_i928.AssignmentRepository>()),
    );
    gh.lazySingleton<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        gh<_i1038.LoginUseCase>(),
        gh<_i698.LogoutUseCase>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.lazySingleton<_i683.ProfileRemoteDataSource>(
      () => _i683.ProfileRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i598.CourseRemoteDataSource>(
      () => _i598.CourseRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i749.CourseRepository>(
      () => _i657.CourseRepositoryImpl(gh<_i598.CourseRemoteDataSource>()),
    );
    gh.factory<_i407.AssignmentsCubit>(
      () => _i407.AssignmentsCubit(
        gh<_i928.AssignmentRepository>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.factory<_i633.StudentAssignmentsCubit>(
      () => _i633.StudentAssignmentsCubit(
        gh<_i928.AssignmentRepository>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i683.ProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i448.AddContentUseCase>(
      () => _i448.AddContentUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i113.AddLessonUseCase>(
      () => _i113.AddLessonUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i865.CreateModuleUseCase>(
      () => _i865.CreateModuleUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i26.GetAssignedCoursesUseCase>(
      () => _i26.GetAssignedCoursesUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i1055.GetCourseDetailsUseCase>(
      () => _i1055.GetCourseDetailsUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i773.GetEnrolledCoursesUseCase>(
      () => _i773.GetEnrolledCoursesUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i763.GetMyProfileUseCase>(
      () => _i763.GetMyProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i382.CoursesCubit>(
      () => _i382.CoursesCubit(
        gh<_i773.GetEnrolledCoursesUseCase>(),
        gh<_i26.GetAssignedCoursesUseCase>(),
      ),
    );
    gh.lazySingleton<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(gh<_i763.GetMyProfileUseCase>()),
    );
    gh.factory<_i445.CourseDetailsCubit>(
      () => _i445.CourseDetailsCubit(
        gh<_i1055.GetCourseDetailsUseCase>(),
        gh<_i865.CreateModuleUseCase>(),
        gh<_i113.AddLessonUseCase>(),
        gh<_i448.AddContentUseCase>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i1045.DioModule {}
