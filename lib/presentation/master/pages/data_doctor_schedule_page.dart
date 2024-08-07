import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fic_frontend/core/components/buttons.dart';
import 'package:flutter_fic_frontend/core/components/spaces.dart';
import 'package:flutter_fic_frontend/core/constants/colors.dart';
import 'package:flutter_fic_frontend/presentation/home/widget/build_app_bar.dart';
import 'package:flutter_fic_frontend/presentation/master/bloc/data_doctor/data_doctor_bloc.dart';
import 'package:flutter_fic_frontend/presentation/master/bloc/data_doctor_schedule/data_doctor_schedule_bloc.dart';

class DoctorSchedulePage extends StatefulWidget {
  const DoctorSchedulePage({super.key});

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context
        .read<DataDoctorScheduleBloc>()
        .add(const DataDoctorScheduleEvent.getDoctorSchedules());

    super.initState();
  }

  int _sortDays(String a, String b) {
    Map<String, int> dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    int indexA = dayOrder[a]!;
    int indexB = dayOrder[b]!;

    return indexA.compareTo(indexB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: BuildAppBar(
          title: 'Data Jadwal Dokter',
          withSearchInput: true,
          searchController: searchController,
          searchChanged: (_) {
            if (searchController.text.isNotEmpty &&
                searchController.text.length > 2) {
              print("Textnya " + searchController.text);
              context
                  .read<DataDoctorScheduleBloc>()
                  .add(DataDoctorScheduleEvent.getDoctorSchedulesByDoctorName(searchController.text));
            } else {
              context
                  .read<DataDoctorScheduleBloc>()
                  .add(const DataDoctorScheduleEvent.getDoctorSchedules());
            }
          },
          searchHint: 'Cari Jadwal Dokter',
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(24.0), children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.stroke),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              scrollDirection: Axis.horizontal,
              child:
                  BlocListener<DataDoctorScheduleBloc, DataDoctorScheduleState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                        backgroundColor: AppColors.red,
                      ));
                    },
                  );
                },
                child: BlocListener<DataDoctorScheduleBloc,
                    DataDoctorScheduleState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      },
                    );
                  },
                  child: BlocBuilder<DataDoctorScheduleBloc,
                      DataDoctorScheduleState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        loaded: (schedules) {
                          return BlocBuilder<DataDoctorScheduleBloc,
                              DataDoctorScheduleState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                loading: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                loaded: (doctorSchedules) {
                                  List<String> days = doctorSchedules
                                      .map((e) => e.day!)
                                      .toSet()
                                      .toList();

                                  days.sort(_sortDays);

                                  //Kelompokkan jadwal dokter berdasarkan nama dokter dan hari

                                  Map<String, Map<String, String>>
                                      groupSchedules = {};

                                  for (var schedule in doctorSchedules) {
                                    if (!groupSchedules.containsKey(
                                        schedule.doctor!.doctorName)) {
                                      groupSchedules[
                                          schedule.doctor!.doctorName!] = {
                                        for (var day in days) day: '-',
                                      };
                                    }

                                    groupSchedules[schedule.doctor!
                                            .doctorName!]![schedule.day!] =
                                        schedule.time ?? '-';
                                  }

                                  //membuat data jadwal dokter berdasarkan hari

                                  List<DataRow> dataRows = [];
                                  dataRows =
                                      groupSchedules.entries.map((entry) {
                                    List<DataCell> cells = [
                                      DataCell(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              entry.key,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(doctorSchedules
                                                    .firstWhere((element) =>
                                                        element.doctor!
                                                            .doctorName ==
                                                        entry.key)
                                                    .doctor!
                                                    .doctorSpecialist ??
                                                ''),
                                          ],
                                        ),
                                      ),
                                      for (String day in days)
                                        DataCell(Center(
                                          child: Text(
                                              groupSchedules[entry.key]![day] ??
                                                  '-'),
                                        ))
                                    ];

                                    return DataRow(cells: cells);
                                  }).toList();

                                  return DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Button.filled(
                                            onPressed: () {},
                                            label: 'Nama Dokter',
                                            width: null,
                                            color: AppColors.title,
                                            textColor: AppColors.black
                                                .withOpacity(0.5),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      for (String day in days)
                                        DataColumn(
                                          label: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Button.filled(
                                              onPressed: () {},
                                              label: day,
                                              width: null,
                                              color: AppColors.white,
                                              textColor: AppColors.black
                                                  .withOpacity(0.5),
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                    ],
                                    rows: dataRows.isEmpty
                                        ? [
                                            const DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Icon(Icons.highlight_off),
                                                    SpaceWidth(4.0),
                                                    Text(
                                                        'Data tidak ditemukan..'),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ]
                                        : dataRows,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ))
      ]),
    );
  }
}
