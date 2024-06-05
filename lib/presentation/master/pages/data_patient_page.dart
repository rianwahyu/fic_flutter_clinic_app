import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fic_frontend/core/components/buttons.dart';
import 'package:flutter_fic_frontend/core/components/spaces.dart';
import 'package:flutter_fic_frontend/core/constants/colors.dart';
import 'package:flutter_fic_frontend/presentation/home/widget/build_app_bar.dart';
import 'package:flutter_fic_frontend/presentation/master/bloc/data_patients/data_patients_bloc.dart';

class DataPatientPage extends StatefulWidget {
  const DataPatientPage({super.key});

  @override
  State<DataPatientPage> createState() => _DataPatientPageState();
}

class _DataPatientPageState extends State<DataPatientPage> {
  final SearchController searchController = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<DataPatientsBloc>().add(const DataPatientsEvent.getPatients());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: BuildAppBar(
          title: 'Data Pasien',
          withSearchInput: true,
          searchController: searchController,
          searchChanged: (_) {
            if (searchController.text.isNotEmpty &&
                searchController.text.length > 2) {
              context.read<DataPatientsBloc>().add(
                  DataPatientsEvent.getPatientByNIK(searchController.text));
            } else {
              context
                  .read<DataPatientsBloc>()
                  .add(const DataPatientsEvent.getPatients());
            }
          },
          searchHint: 'Cari Pasien',
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
            child: BlocListener<DataPatientsBloc, DataPatientsState>(
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
              child: BlocListener<DataPatientsBloc, DataPatientsState>(
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
                child: BlocBuilder<DataPatientsBloc, DataPatientsState>(
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
                      loaded: (patients) {
                        return DataTable(
                          columns: [
                           
                            DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Button.filled(
                                  onPressed: () {},
                                  label: 'Nama Pasien',
                                  width: null,
                                  color: AppColors.title,
                                  textColor: AppColors.black.withOpacity(0.5),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Button.filled(
                                  onPressed: () {},
                                  label: 'Jenis Kelamin',
                                  width: null,
                                  color: AppColors.title,
                                  textColor: AppColors.black.withOpacity(0.5),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Button.filled(
                                  onPressed: () {},
                                  label: 'Tanggal Lahir',
                                  width: null,
                                  color: AppColors.title,
                                  textColor: AppColors.black.withOpacity(0.5),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                             DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Button.filled(
                                  onPressed: () {},
                                  label: 'NIK',
                                  width: null,
                                  color: AppColors.title,
                                  textColor: AppColors.black.withOpacity(0.5),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            
                          ],
                          rows: patients.isEmpty
                              ? [
                                  const DataRow(
                                    cells: [
                                      DataCell(Row(
                                        children: [
                                          Icon(Icons.highlight_off),
                                          SpaceWidth(4.0),
                                          Text('Data tidak ditemukan..'),
                                        ],
                                      )),
                                      DataCell.empty,
                                      DataCell.empty,
                                      DataCell.empty,
                                    ],
                                  ),
                                ]
                              : patients
                                  .map(
                                    (patient) => DataRow(cells: [
                                      DataCell(Text(
                                        patient.name ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(
                                          Text(patient.gender ?? '')),
                                      DataCell(Text(patient.birthDate!.toString() ?? '')),
                                      DataCell(Text(patient.nik ?? '')),
                                      
                                    ]),
                                  )
                                  .toList(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
