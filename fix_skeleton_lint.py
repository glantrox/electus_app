import os

base = 'lib/presentation/components/common/skeleton'

files = [
    'candidate_card_skeleton.dart',
    'notification_card_skeleton.dart',
    'shimmer_skeleton.dart',
    'stat_card_skeleton.dart'
]

for file in files:
    path = os.path.join(base, file)
    with open(path, 'r') as f:
        content = f.read()
    
    content = content.replace("import 'package:electus_app/core/theme/colors.dart';\n", "")
    
    with open(path, 'w') as f:
        f.write(content)

print("Fixed")
