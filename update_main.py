import os

main_file = 'lib/main.dart'

with open(main_file, 'r') as f:
    content = f.read()

imports = """
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_event.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_event.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_event.dart';
"""

content = content.replace("import 'package:electus_app/injection.dart';", imports + "import 'package:electus_app/injection.dart';")

providers = """
        BlocProvider<CandidateActionBloc>(create: (context) => di<CandidateActionBloc>()),
        BlocProvider<ProfileBloc>(create: (context) => di<ProfileBloc>()..add(FetchProfileEvent())),
        BlocProvider<NotificationBloc>(create: (context) => di<NotificationBloc>()..add(FetchNotificationsEvent())),
        BlocProvider<AnalyticsBloc>(create: (context) => di<AnalyticsBloc>()..add(FetchAnalyticsEvent())),
"""

content = content.replace("        BlocProvider<CandidateActionBloc>(create: (context) => di<CandidateActionBloc>()),", providers)

with open(main_file, 'w') as f:
    f.write(content)

print("Updated main.dart")
