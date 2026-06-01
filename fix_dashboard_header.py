import os

def replace_in_file(file_path, old_text, new_text):
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
    with open(file_path, 'r') as f:
        content = f.read()
    content = content.replace(old_text, new_text)
    with open(file_path, 'w') as f:
        f.write(content)
    print(f"Updated {file_path}")

base = 'lib'

# 1. Fix baseUrl in Remote Data Sources
replace_in_file(
    f"{base}/data/datasources/analytics/analytics_remote_data_source.dart",
    "'http://10.0.2.2:3000/api'",
    "'http://localhost:3000'"
)

replace_in_file(
    f"{base}/data/datasources/notification/notification_remote_data_source.dart",
    "'http://10.0.2.2:3000/api'",
    "'http://localhost:3000'"
)

replace_in_file(
    f"{base}/data/datasources/user/user_remote_data_source.dart",
    "'http://10.0.2.2:3000/api'; // Assuming default base URL",
    "'http://localhost:3000';"
)

# 2. Update dashboard_header.dart to accept data
header_path = f"{base}/presentation/components/dashboard/dashboard_header.dart"
with open(header_path, 'r') as f:
    header_content = f.read()

# Add properties
header_content = header_content.replace(
    "final double safeAreaTop;\n\n  DashboardHeaderDelegate({required this.safeAreaTop});",
    "final double safeAreaTop;\n  final String userName;\n  final String avatarUrl;\n  final String totalApplicants;\n\n  DashboardHeaderDelegate({\n    required this.safeAreaTop,\n    required this.userName,\n    required this.avatarUrl,\n    required this.totalApplicants,\n  });"
)

# Replace Olan Maulana
header_content = header_content.replace(
    "Text(\n                                    'Olan Maulana',",
    "Text(\n                                    userName,"
)

# Replace avatar
header_content = header_content.replace(
    "backgroundImage: NetworkImage(\n                                  'https://i.pravatar.cc/150?img=47',\n                                ),",
    "backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : const NetworkImage('https://i.pravatar.cc/150?img=47'),"
)

# Replace 1,248,123
header_content = header_content.replace(
    "Text(\n                        '1,248,123',",
    "Text(\n                        totalApplicants,"
)

with open(header_path, 'w') as f:
    f.write(header_content)
print(f"Updated {header_path}")

# 3. Update dashboard.dart to pass the data
dashboard_path = f"{base}/presentation/pages/dashboard.dart"
with open(dashboard_path, 'r') as f:
    dash_content = f.read()

# Make sure ProfileBloc is imported
if "import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';" not in dash_content:
    dash_content = dash_content.replace(
        "import 'package:electus_app/presentation/bloc/analytics/analytics_state.dart';",
        "import 'package:electus_app/presentation/bloc/analytics/analytics_state.dart';\nimport 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';\nimport 'package:electus_app/presentation/bloc/profile/profile_state.dart';"
    )

import re

# We need to wrap the SliverPersistentHeader(delegate: DashboardHeaderDelegate) with MultiBlocBuilder basically.
# Instead of doing that, we can wrap the whole CustomScrollView with a BlocBuilder for ProfileBloc, or just the header using a proxy widget, but slivers must be direct children of CustomScrollView.
# However, Sliver widgets can be wrapped with BlocBuilder without issues in CustomScrollView!

old_header = """          SliverPersistentHeader(
            pinned: true,
            delegate: DashboardHeaderDelegate(
              safeAreaTop: MediaQuery.of(context).padding.top,
            ),
          ),"""

new_header = """          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              return BlocBuilder<AnalyticsBloc, AnalyticsState>(
                builder: (context, analyticsState) {
                  String userName = 'Guest';
                  String avatarUrl = '';
                  String totalApplicants = '0';

                  if (profileState is ProfileLoaded) {
                    userName = profileState.user.fullName;
                    avatarUrl = profileState.user.avatarUrl;
                  }
                  
                  if (analyticsState is AnalyticsLoaded) {
                    totalApplicants = analyticsState.overview.totalApplicants.value.toString();
                  }

                  return SliverPersistentHeader(
                    pinned: true,
                    delegate: DashboardHeaderDelegate(
                      safeAreaTop: MediaQuery.of(context).padding.top,
                      userName: userName,
                      avatarUrl: avatarUrl,
                      totalApplicants: totalApplicants,
                    ),
                  );
                },
              );
            },
          ),"""

dash_content = dash_content.replace(old_header, new_header)

with open(dashboard_path, 'w') as f:
    f.write(dash_content)
print(f"Updated {dashboard_path}")
