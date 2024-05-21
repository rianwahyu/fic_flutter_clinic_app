import 'package:bloc/bloc.dart';
import 'package:flutter_fic_frontend/data/datasource/auth_remote_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource _authRemoteDataSource;
  LogoutBloc(this._authRemoteDataSource) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const _Loading());

      final response = await _authRemoteDataSource.logout();
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(
          const _Success(),
        ),
      );
    });
  }
}
