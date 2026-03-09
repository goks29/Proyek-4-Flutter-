import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logbook_app_001/features/logbook/log_controller.dart';
import 'package:logbook_app_001/features/auth/login_view.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';
import 'package:logbook_app_001/services/access_control_service.dart';

class LogView extends StatefulWidget {
  final String username;
  final String role;

  const LogView({super.key, required this.username, required this.role});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late final LogController _controller;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<String> _categories = ['Pribadi', 'Pekerjaan', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _controller = LogController(widget.username, widget.role);
    Future.microtask(
      () => _controller.initDatabase().catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  Expanded(
                    child: Text("Offline Mode: Tidak dapat tersambung ke database"),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Urgent':
        return Colors.red.shade100;
      case 'Pekerjaan':
        return Colors.blue.shade100;
      case 'Pribadi':
      default:
        return Colors.green.shade100;
    }
  }

  void _showAddLogDialog() {
    String selectedCategory = 'Pribadi';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Tambah Catatan Baru"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: "Judul Catatan",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: "Isi Deskripsi",
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _contentController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty ||
                        _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Title dan description tidak boleh kosong!",
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      _controller.addLog(
                        _titleController.text,
                        _contentController.text,
                        selectedCategory,
                      );
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditLogDialog(int index, LogModel log) {
    _titleController.text = log.title;
    _contentController.text = log.description;
    String selectedCategory = log.category;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Catatan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _titleController),
                  const SizedBox(height: 10),
                  TextField(controller: _contentController),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _contentController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty ||
                        _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Title dan description tidak boleh kosong!",
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      _controller.updateLog(
                        index,
                        _titleController.text,
                        _contentController.text,
                        selectedCategory,
                      );
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text(
            "Apakah Anda yakin? Data yang belum disimpan mungkin akan hilang.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: const Text(
                "Ya, Keluar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Logbook: ${widget.username}"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _controller.isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Menghubungkan data ke databse"),
                ],
              ),
            );
          }
          //search bar
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) => _controller.searchLog(value),
                  decoration: InputDecoration(
                    labelText: "Cari Catatan...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              //list log kosong
              Expanded(
                child: ValueListenableBuilder<List<LogModel>>(
                  valueListenable: _controller.filteredLogs,
                  builder: (context, currentLogs, child) {
                    if (currentLogs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text("Belum ada catatan di Cloud."),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _showAddLogDialog,
                              child: const Text("Buat Catatan Pertama"),
                            ),
                          ],
                        ),
                      );
                    }
                    //refresh
                    return RefreshIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        await _controller.loadFromDisk();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Data berhasil diperbaharui"),
                              duration: Duration(seconds:1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },

                      //list log ada
                      child:  ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: currentLogs.length,
                        itemBuilder: (context, index) {
                          final log = currentLogs[index];

                          bool canDelete = AccessControlService.canPerform(_controller.currentUser.role, 'delete', isOwner: log.authorId == _controller.currentUser.id);
                          
                          return Dismissible(
                            key: Key(log.id?.toString() ?? log.date.toString()),
                            direction: canDelete ? DismissDirection.endToStart : DismissDirection.none,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) =>
                                _controller.removeLog(index),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: _getCategoryColor(log.category),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Icon(
                                  log.isSynced ? Icons.cloud_done : Icons.cloud_off,
                                  color: log.isSynced ? Colors.green : Colors.orange,
                                ),
                                title: Text(
                                  log.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(log.description),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat.yMMMMEEEEd('id').format(log.date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm').format(log.date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Text(
                                          log.category,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (AccessControlService.canPerform(_controller.currentUser.role, 'update', isOwner:log.authorId == _controller.currentUser.id))
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                      ),
                                      onPressed: () => _showEditLogDialog(index, log),
                                    ),
                                    if (AccessControlService.canPerform(_controller.currentUser.role, 'delete', isOwner:log.authorId == _controller.currentUser.id))
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _controller.removeLog(index),
                                        )
                                  ]
                                )
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      //add button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLogDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
