import 'package:flutter/material.dart';
import 'package:flutter_fic_frontend/core/assets/assets.gen.dart';
import 'package:flutter_fic_frontend/core/components/button_menu.dart';
import 'package:flutter_fic_frontend/core/components/spaces.dart';
import 'package:flutter_fic_frontend/core/core.dart';
import 'package:flutter_fic_frontend/presentation/home/widget/build_app_bar.dart';
import 'package:flutter_fic_frontend/presentation/master/pages/data_doctor_page.dart';
import 'package:flutter_fic_frontend/presentation/master/pages/data_doctor_schedule_page.dart';
import 'package:flutter_fic_frontend/presentation/master/pages/data_patient_page.dart';

class MasterPage extends StatefulWidget {
  final void Function(int index) onTap;
  const MasterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: BuildAppBar(
          title: 'Data Master',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 110.0),
        child: Wrap(
          runSpacing: 16,
          children: [
            ButtonMenu(
              label: 'Data Dokter',
              iconPath: Assets.images.menu.data.path,
              onPressed: () {
                //widget.onTap(1);
                context.push(const DataDoctorPage());
              },
            ),
            const SpaceWidth(45.0),
            ButtonMenu(
              label: 'Data Pasien',
              iconPath: Assets.images.menu.data.path,
              onPressed: () {
                // widget.onTap(2);
                //context.push(const DataPatientPage());
                context.push(const DataPatientPage());
              },
            ),
            const SpaceWidth(45.0),
            ButtonMenu(
              label: 'Jadwal Dokter',
              iconPath: Assets.images.menu.jadwal.path,
              onPressed: () {
                widget.onTap(3);
                //context.push(const DataDoctorSchedulePage());
                context.push(const DoctorSchedulePage());
              },
            ),
            const SpaceWidth(45.0),
            ButtonMenu(
              label: 'Layanan',
              iconPath: Assets.images.menu.layanan.path,
              onPressed: () {
                widget.onTap(4);
                //context.push(const DataServicePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
