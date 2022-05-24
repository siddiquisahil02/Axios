import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_manager/cubit/AllPermissions/all_permissions_cubit.dart';
import 'package:society_manager/cubit/Complaints/complaints_cubit.dart';
import 'package:society_manager/cubit/Emergency/emergency_cubit.dart';
import 'package:society_manager/cubit/Home/home_cubit.dart';
import 'package:society_manager/cubit/Login/login_cubit.dart';
import 'package:society_manager/cubit/Meeting/meeting_cubit.dart';
import 'package:society_manager/cubit/Notice/notice_cubit.dart';
import 'package:society_manager/cubit/Permission/permission_cubit.dart';
import 'package:society_manager/cubit/Register/register_cubit.dart';
import 'package:society_manager/views/all_permissions.dart';
import 'package:society_manager/views/complaints_page.dart';
import 'package:society_manager/views/emergency_page.dart';
import 'package:society_manager/views/home_page.dart';
import 'package:society_manager/views/login_page.dart';
import 'package:society_manager/views/meeting_page.dart';
import 'package:society_manager/views/notice_board_page.dart';
import 'package:society_manager/views/permission_page.dart';
import 'package:society_manager/views/register_page.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => FirebaseAuth.instance.currentUser == null ? BlocProvider(
              create: (BuildContext context)=> LoginCubit(),
              child: LoginPage(),
            ):BlocProvider(
              create: (BuildContext context)=> HomeCubit(),
              child: const HomePage(),
            )
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> HomeCubit(),
              child: const HomePage(),
            )
        );
      case '/register':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> RegisterCubit(),
              child: const RegisterPage(),
            )
        );
      case '/allPermissions':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> AllPermissionsCubit(),
              child: const AllPermissions(),
            )
        );
      case '/approved':
        final arg = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> PermissionCubit(),
              child: PermissionPage(
                id: arg as String,
              ),
            )
        );
      case '/notice':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> NoticeCubit(),
              child: const NoticeBoardPage(),
            )
        );
      case '/emergency':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> EmergencyCubit(),
              child: const EmergencyPage(),
            )
        );
      case '/complaints':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> ComplaintsCubit(),
              child: const ComplaintsPage(),
            )
        );
      case '/meeting':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> MeetingCubit(),
              child: const MeetingPage(),
            )
        );
      default:
        return null;
    }
  }
}