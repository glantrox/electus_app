import re

with open('lib/presentation/pages/dashboard.dart', 'r') as f:
    text = f.read()

to_replace = """                  const SizedBox(height: 32),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _FilterChip(label: 'All Roles', isSelected: true),
                        SizedBox(width: 8),
                        _FilterChip(label: 'Frontend Dev', isSelected: false),
                        SizedBox(width: 8),
                        _FilterChip(label: 'UI/UX Designer', isSelected: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),"""

new_code = """                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterPersistentHeaderDelegate(),
          ),"""

text = text.replace(to_replace, new_code)

delegate_code = """
class _FilterPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColor.background, // Match background so cards hide when sliding under
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      alignment: Alignment.center,
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: const [
            _FilterChip(label: 'All Roles', isSelected: true),
            SizedBox(width: 8),
            _FilterChip(label: 'Frontend Dev', isSelected: false),
            SizedBox(width: 8),
            _FilterChip(label: 'UI/UX Designer', isSelected: false),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 68.0;

  @override
  double get minExtent => 68.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _FilterChip extends StatelessWidget {"""

text = text.replace("class _FilterChip extends StatelessWidget {", delegate_code)

with open('lib/presentation/pages/dashboard.dart', 'w') as f:
    f.write(text)
print("done")
