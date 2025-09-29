import 'package:flutter/material.dart';

class FileExplorerWidget extends StatefulWidget {
  final List<FileItem> files;
  final String currentFile;
  final Function(String) onFileSelected;
  final Function() onNewFile;
  final Function(String) onDeleteFile;
  final bool isDarkMode;

  const FileExplorerWidget({
    super.key,
    required this.files,
    required this.currentFile,
    required this.onFileSelected,
    required this.onNewFile,
    required this.onDeleteFile,
    this.isDarkMode = false,
  });

  @override
  State<FileExplorerWidget> createState() => _FileExplorerWidgetState();
}

class _FileExplorerWidgetState extends State<FileExplorerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF252526) : Colors.grey[100],
        border: Border(
          right: BorderSide(
            color: widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          // File Explorer Header
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
                        Icons.folder,
                        size: 16,
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Explorer',
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
                  onPressed: widget.onNewFile,
                  tooltip: 'New File',
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),

          // File List
          Expanded(
            child: ListView.builder(
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = widget.files[index];
                final isSelected = file.name == widget.currentFile;

                return Container(
                  color: isSelected
                      ? (widget.isDarkMode
                            ? const Color(0xFF37373D)
                            : Colors.blue[100])
                      : Colors.transparent,
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      _getFileIcon(file.type),
                      size: 16,
                      color: _getFileIconColor(file.type),
                    ),
                    title: Text(
                      file.name,
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (file.isOpen)
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: widget.isDarkMode
                                ? Colors.green
                                : Colors.blue,
                          ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: widget.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'open':
                                widget.onFileSelected(file.name);
                                break;
                              case 'delete':
                                _deleteFile(file);
                                break;
                              case 'rename':
                                _renameFile(file);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'open',
                              child: Text('Open'),
                            ),
                            const PopupMenuItem(
                              value: 'rename',
                              child: Text('Rename'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => widget.onFileSelected(file.name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(FileType type) {
    switch (type) {
      case FileType.cpp:
        return Icons.code;
      case FileType.header:
        return Icons.description;
      case FileType.markdown:
        return Icons.text_snippet;
      case FileType.folder:
        return Icons.folder;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileIconColor(FileType type) {
    switch (type) {
      case FileType.cpp:
        return Colors.blue;
      case FileType.header:
        return Colors.green;
      case FileType.markdown:
        return Colors.orange;
      case FileType.folder:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _deleteFile(FileItem file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.files.remove(file);
              });
              widget.onDeleteFile(file.name);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _renameFile(FileItem file) {
    final controller = TextEditingController(text: file.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'File name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                file.name = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}

class FileItem {
  String name;
  FileType type;
  bool isOpen;

  FileItem({required this.name, required this.type, this.isOpen = false});
}

enum FileType { cpp, header, markdown, folder, other }
