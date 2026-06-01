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

# 1. Update token keys in user, notification, analytics
replace_in_file(
    f"{base}/data/datasources/analytics/analytics_remote_data_source.dart",
    "sharedPreferences.getString('auth_token')",
    "sharedPreferences.getString('CACHED_AUTH_TOKEN')"
)

replace_in_file(
    f"{base}/data/datasources/notification/notification_remote_data_source.dart",
    "sharedPreferences.getString('auth_token')",
    "sharedPreferences.getString('CACHED_AUTH_TOKEN')"
)

replace_in_file(
    f"{base}/data/datasources/user/user_remote_data_source.dart",
    "sharedPreferences.getString('auth_token')",
    "sharedPreferences.getString('CACHED_AUTH_TOKEN')"
)

# 2. Update CandidateDataSourceImpl to use SharedPreferences
candidate_ds_path = f"{base}/data/datasource/candidate/candidate_data_source_impl.dart"
with open(candidate_ds_path, 'r') as f:
    cand_content = f.read()

import_sp = "import 'package:shared_preferences/shared_preferences.dart';\n"
if "shared_preferences.dart" not in cand_content:
    cand_content = cand_content.replace("import 'package:http/http.dart' as http;", "import 'package:http/http.dart' as http;\n" + import_sp)

cand_content = cand_content.replace(
    "CandidateDataSourceImpl({required this.client});",
    "final SharedPreferences sharedPreferences;\n\n  CandidateDataSourceImpl({required this.client, required this.sharedPreferences});"
)

cand_content = cand_content.replace(
    "Map<String, String> _headers() => {\n    'Content-Type': 'application/json',\n    // 'Authorization': 'Bearer $token', // Add token if needed\n  };",
    "Map<String, String> _headers() {\n    final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');\n    return {\n      'Content-Type': 'application/json',\n      if (token != null) 'Authorization': 'Bearer $token',\n    };\n  }"
)

# Also fix the upload request headers
cand_content = cand_content.replace(
    "// request.headers.addAll({'Authorization': 'Bearer $token'});",
    "final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');\n    if (token != null) {\n      request.headers.addAll({'Authorization': 'Bearer $token'});\n    }"
)

with open(candidate_ds_path, 'w') as f:
    f.write(cand_content)
print(f"Updated {candidate_ds_path}")

# 3. Update injection.dart for CandidateDataSourceImpl
injection_path = f"{base}/injection.dart"
with open(injection_path, 'r') as f:
    inj_content = f.read()

inj_content = inj_content.replace(
    "di.registerLazySingleton<CandidateDataSource>(\n      () => CandidateDataSourceImpl(client: di()));",
    "di.registerLazySingleton<CandidateDataSource>(\n      () => CandidateDataSourceImpl(client: di(), sharedPreferences: di()));"
)
with open(injection_path, 'w') as f:
    f.write(inj_content)
print(f"Updated {injection_path}")
