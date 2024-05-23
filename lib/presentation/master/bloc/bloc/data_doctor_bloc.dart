import 'package:bloc/bloc.dart';
import 'package:flutter_fic_frontend/data/datasource/master_remote_datasource.dart';
import 'package:flutter_fic_frontend/data/models/response/master_doctor_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_doctor_event.dart';
part 'data_doctor_state.dart';
part 'data_doctor_bloc.freezed.dart';

class DataDoctorBloc extends Bloc<DataDoctorEvent, DataDoctorState> {
  final MasterRemoteDatasource _masterRemoteDatasource;
  DataDoctorBloc(
    this._masterRemoteDatasource,
  ) : super(_Initial()) {
    on<_GetDoctors>((event, emit) async {
      emit(const _Loading());

      final result = await _masterRemoteDatasource.getDoctors();
      result.fold((l) => emit(_Error(l)), (r) => emit(_Loaded(r.data ?? [])));
    });

    on<_GetDoctorByName>((event, emit) async {
      emit(const _Loading());
      final result =
          await _masterRemoteDatasource.getDoctorsByName(event.doctorName);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
