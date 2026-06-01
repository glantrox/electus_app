import os

test_path = 'test/data/datasource/candidate_data_source_impl_test.dart'
with open(test_path, 'r') as f:
    content = f.read()

import_sp = "import 'package:shared_preferences/shared_preferences.dart';\n"
if import_sp not in content:
    content = content.replace("import 'package:http/http.dart' as http;", "import 'package:http/http.dart' as http;\n" + import_sp)

content = content.replace("class MockHttpClient extends Mock implements http.Client {}", "class MockHttpClient extends Mock implements http.Client {}\nclass MockSharedPreferences extends Mock implements SharedPreferences {}")

content = content.replace("  late MockHttpClient mockHttpClient;", "  late MockHttpClient mockHttpClient;\n  late MockSharedPreferences mockSharedPreferences;")

content = content.replace("    mockHttpClient = MockHttpClient();\n    datasource = CandidateDataSourceImpl(client: mockHttpClient);", "    mockHttpClient = MockHttpClient();\n    mockSharedPreferences = MockSharedPreferences();\n    when(() => mockSharedPreferences.getString('CACHED_AUTH_TOKEN')).thenReturn('test_token');\n    datasource = CandidateDataSourceImpl(client: mockHttpClient, sharedPreferences: mockSharedPreferences);")

with open(test_path, 'w') as f:
    f.write(content)
print("Updated test file")
