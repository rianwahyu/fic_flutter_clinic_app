import 'package:flutter/material.dart';
import 'package:flutter_fic_frontend/core/constants/colors.dart';
import 'package:flutter_fic_frontend/data/datasource/auth_local_datasource.dart';
import 'package:flutter_fic_frontend/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_fic_frontend/data/datasource/master_remote_datasource.dart';
import 'package:flutter_fic_frontend/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_fic_frontend/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_fic_frontend/presentation/auth/pages/login_page.dart';
import 'package:flutter_fic_frontend/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_fic_frontend/presentation/master/bloc/data_doctor/data_doctor_bloc.dart';
import 'package:flutter_fic_frontend/presentation/master/bloc/data_patients/data_patients_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => DataDoctorBloc(MasterRemoteDatasource()),
        ),

        BlocProvider(
          create: (context) => DataPatientsBloc(MasterRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder(
          future: AuthLocalDataSource().isUserLogedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data == true) {
              return const DashboardPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
