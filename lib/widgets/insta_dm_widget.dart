import 'package:flutter/material.dart';

Widget dmSection(
  BuildContext context, {
  required List<Map<String, dynamic>> users,
  required List<Map<String, dynamic>> notes,
}) {
  return _DMView(users: users, notes: notes);
}

class _DMView extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> notes;

  const _DMView({required this.users, required this.notes});

  @override
  State<_DMView> createState() => _DMViewState();
}

class _DMViewState extends State<_DMView> {
  int selectedFilter = 0;
  String searchQuery = "";

  final filters = ["Primary", "Requests", "General"];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = widget.users.where((user) {
      final name = (user['name'] as String).toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        const _DMAppBar(),
        _DMSearchBar(
          onChanged: (val) {
            setState(() {
              searchQuery = val;
            });
          },
        ),
        _DMNotesRow(notes: widget.notes),
        _DMFilterBar(
          filters: filters,
          selected: selectedFilter,
          onTap: (index) {
            setState(() {
              selectedFilter = index;
            });
          },
        ),
        Expanded(child: _DMUserList(users: filteredUsers)),
      ],
    );
  }
}

class _DMAppBar extends StatelessWidget {
  const _DMAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.format_list_bulleted, size: 28),
          const Spacer(),
          const Row(
            children: [
              Text(
                "_ig__skull_",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
          const Spacer(),
          const Icon(Icons.trending_up, size: 28),
          const SizedBox(width: 14),
          const Icon(Icons.edit_square, size: 26),
        ],
      ),
    );
  }
}

class _DMSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const _DMSearchBar({this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search or ask Meta AI",
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 24,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class _DMNotesRow extends StatelessWidget {
  final List<Map<String, dynamic>> notes;

  const _DMNotesRow({required this.notes});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isDark ? Colors.grey[800] : Colors.white;

    return SizedBox(
      height: 140, // Expanded height for bubbles
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: notes.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final note = notes[index];
          final noteBubbleText = note['noteText'] as String?;
          final isBadge = note['isBadge'] == true;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 85, // Fixed width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 100,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: AssetImage(note["image"]),
                        ),

                        // Bubble or Badge
                        if (noteBubbleText != null)
                          Positioned(
                            top: -4,
                            child: isBadge
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      noteBubbleText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(
                                    constraints: const BoxConstraints(maxWidth: 80),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: bubbleColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      noteBubbleText,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note["name"],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DMFilterBar extends StatelessWidget {
  final List<String> filters;
  final int selected;
  final Function(int) onTap;

  const _DMFilterBar({
    required this.filters,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final textColor = isDark ? Colors.white : Colors.black;
    final selectedBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 18, color: textColor),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 18, color: textColor),
                ],
              ),
            ),
            ...List.generate(filters.length, (index) {
              final isSelected = selected == index;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedBgColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : borderColor,
                      ),
                    ),
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DMUserList extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const _DMUserList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return DMUserTile(user: users[index]);
      },
    );
  }
}

class DMUserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const DMUserTile({super.key, required this.user});

  Color? _ringColor(String? status) {
    if (status == "new") return Colors.pink;
    if (status == "seen") return Colors.grey[400];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = _ringColor(user["storyStatus"]);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: ringColor != null ? const EdgeInsets.all(3) : null,
        decoration: ringColor != null
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 2.5),
              )
            : null,
        child: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[300],
          backgroundImage: AssetImage(user["image"]),
        ),
      ),
      title: Text(
        user["name"],
        style: TextStyle(fontSize: 15, color: textColor),
      ),
      subtitle: Text(
        user["status"],
        style: TextStyle(fontSize: 13, color: subtitleColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: GestureDetector(
        onTap: user["onCameraTap"],
        child: Icon(Icons.camera_alt_outlined, size: 28, color: subtitleColor),
      ),
    );
  }
}
