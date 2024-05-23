part of 'data_doctor_bloc.dart';

@freezed
class DataDoctorEvent with _$DataDoctorEvent {
  const factory DataDoctorEvent.started() = _Started;
  const factory DataDoctorEvent.getDoctors() = _GetDoctors;
  const factory DataDoctorEvent.getDoctorByName(String doctorName) =
      _GetDoctorByName;
}
