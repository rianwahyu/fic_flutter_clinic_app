part of 'data_doctor_schedule_bloc.dart';

@freezed
class DataDoctorScheduleEvent with _$DataDoctorScheduleEvent {
  const factory DataDoctorScheduleEvent.started() = _Started;
  const factory DataDoctorScheduleEvent.getDoctorSchedules() = _GetDoctorSchedules;
  const factory DataDoctorScheduleEvent.getDoctorSchedulesByDoctorName(String name) = _GetDoctorSchedulesByDoctorName;
}
