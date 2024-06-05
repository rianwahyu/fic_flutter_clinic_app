import 'package:bloc/bloc.dart';
import 'package:flutter_fic_frontend/data/datasource/master_remote_datasource.dart';
import 'package:flutter_fic_frontend/data/models/response/master_patient_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_patients_event.dart';
part 'data_patients_state.dart';
part 'data_patients_bloc.freezed.dart';

class DataPatientsBloc extends Bloc<DataPatientsEvent, DataPatientsState> {
  final MasterRemoteDatasource _masterRemoteDatasource;
  DataPatientsBloc(
    this._masterRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetPatients>((event, emit) async {
      emit(const _Loading());
      final result = await _masterRemoteDatasource.getPatients();
      emit(
        result.fold(
          (l) => _Error(l),
          (r) => _Loaded(r.data ?? []),
        ),
      );
    });

    on<_GetPatientByNIK>((event, emit) async {
      emit(const _Loading());
      final result = await _masterRemoteDatasource.getPatientByNIK(event.nik);
      emit(
        result.fold(
          (l) => _Error(l),
          (r) => _Loaded(r.data ?? []),
        ),
      );
    });
  }
}
