import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_fic_frontend/data/datasource/master_remote_datasource.dart';
import 'package:flutter_fic_frontend/data/models/response/doctor_schedule_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_doctor_schedule_event.dart';
part 'data_doctor_schedule_state.dart';
part 'data_doctor_schedule_bloc.freezed.dart';

class DataDoctorScheduleBloc
    extends Bloc<DataDoctorScheduleEvent, DataDoctorScheduleState> {
  final MasterRemoteDatasource _master_remote_datasource;
  DataDoctorScheduleBloc(
    this._master_remote_datasource,
  ) : super(const _Initial()) {
    on<_GetDoctorSchedules>((event, emit) async {
      emit(const _Loading());
      final result = await _master_remote_datasource.getDoctorSchedules();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });

    on<_GetDoctorSchedulesByDoctorName>((event, emit) async {
      emit(const _Loading());
      final result = await _master_remote_datasource
          .getDoctorSchedulesByDoctorName(event.name);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
