import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/get_my_profile_use_case.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfileUseCase getMyProfileUseCase;

  ProfileCubit(this.getMyProfileUseCase) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    final result = await getMyProfileUseCase();
    
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}
