import 'package:flutter/material.dart';

class ProjectManagerWidget extends StatefulWidget {
  final bool isDarkMode;
  final Function(String) onProjectSelected;

  const ProjectManagerWidget({
    super.key,
    this.isDarkMode = false,
    required this.onProjectSelected,
  });

  @override
  State<ProjectManagerWidget> createState() => _ProjectManagerWidgetState();
}

class _ProjectManagerWidgetState extends State<ProjectManagerWidget> {
  final List<ProjectItem> _projects = [
    ProjectItem(
      name: 'C++ Basics',
      description: 'Learning C++ fundamentals',
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      files: ['main.cpp', 'variables.cpp', 'functions.cpp'],
    ),
    ProjectItem(
      name: 'Data Structures',
      description: 'Implementing common data structures',
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      files: ['array.cpp', 'linked_list.cpp', 'stack.cpp'],
    ),
    ProjectItem(
      name: 'Algorithms',
      description: 'Sorting and searching algorithms',
      lastModified: DateTime.now().subtract(const Duration(days: 3)),
      files: ['bubble_sort.cpp', 'binary_search.cpp', 'quick_sort.cpp'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF252526) : Colors.grey[100],
        border: Border(
          left: BorderSide(
            color: widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          // Project Manager Header
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF2D2D30)
                  : Colors.grey[200],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 16,
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Projects',
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: _createNewProject,
                  tooltip: 'New Project',
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),

          // Project List
          Expanded(
            child: ListView.builder(
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                final project = _projects[index];
                return _buildProjectCard(project);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectItem project) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: widget.isDarkMode ? const Color(0xFF2D2D30) : Colors.white,
      child: InkWell(
        onTap: () => widget.onProjectSelected(project.name),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project name and status
              Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: 20,
                    color: widget.isDarkMode ? Colors.blue : Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      project.name,
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Project description
              Text(
                project.description,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // File count and last modified
              Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 14,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.files.length} files',
                    style: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatLastModified(project.lastModified),
                    style: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // File preview
              if (project.files.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: project.files.take(3).map((file) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? const Color(0xFF37373D)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        file,
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastModified(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _createNewProject() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Project name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _projects.add(
                    ProjectItem(
                      name: controller.text,
                      description: 'New project',
                      lastModified: DateTime.now(),
                      files: ['main.cpp'],
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class ProjectItem {
  final String name;
  final String description;
  final DateTime lastModified;
  final List<String> files;

  ProjectItem({
    required this.name,
    required this.description,
    required this.lastModified,
    required this.files,
  });
}
