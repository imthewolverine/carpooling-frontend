import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_post_bloc.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostScreen extends StatelessWidget {
  Future<String?> getAddressFromLatLng(LatLng point) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] as String?;
      }
    } catch (e) {
      print("Хаяг авахад алдаа гарлаа: $e");
    }
    return null;
  }

  Future<void> showMapPicker({
    required BuildContext context,
    required bool isSource,
    required Function(LatLng, String) onSelected,
  }) async {
    LatLng? selectedPoint;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isSource ? "Эхлэх цэг сонгох" : "Төгсөх цэг сонгох",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(47.918873, 106.917992), // Default: Ulaanbaatar
                        zoom: 13.0,
                        onTap: (tapPosition, latLng) async {
                          selectedPoint = latLng;
                          final address = await getAddressFromLatLng(latLng);
                          setModalState(() {}); // Update map marker dynamically
                          if (address != null) {
                            Navigator.pop(context); // Close modal
                            onSelected(latLng, address);
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        if (selectedPoint != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedPoint!,
                                builder: (ctx) => Icon(
                                  Icons.location_pin,
                                  color: isSource ? Colors.green : Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPostBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Шинэ зар нэмэх'),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AddPostBloc, AddPostState>(
            builder: (context, state) {
              final bloc = context.read<AddPostBloc>();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Picker
                    _buildSectionTitle("Огноо ба цаг сонгох"),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate == null) return;

                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          bloc.add(PickDateTimeEvent(selectedDateTime));
                        }
                      },
                      child: _buildInputField(
                        state.selectedDateTime?.toString() ?? "Огноо ба цаг сонгох",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Source Field
                    _buildSectionTitle("Эхлэх цэг"),
                    GestureDetector(
                      onTap: () {
                        showMapPicker(
                          context: context,
                          isSource: true,
                          onSelected: (point, address) {
                            bloc.add(SelectSourceEvent(point, address));
                          },
                        );
                      },
                      child: _buildInputField(
                        state.sourceAddress ?? "Эхлэх цэг сонгох",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Destination Field
                    _buildSectionTitle("Төгсөх цэг"),
                    GestureDetector(
                      onTap: () {
                        showMapPicker(
                          context: context,
                          isSource: false,
                          onSelected: (point, address) {
                            bloc.add(SelectDestinationEvent(point, address));
                          },
                        );
                      },
                      child: _buildInputField(
                        state.destinationAddress ?? "Төгсөх цэг сонгох",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Address Field
                    _buildSectionTitle("Хаяг"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Дэлгэрэнгүй хаяг оруулна уу",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onChanged: (value) {
                        bloc.add(SaveAdditionalInfoEvent(value, state.description ?? ""));
                      },
                    ),
                    SizedBox(height: 16),

                    // Detail Info Field
                    _buildSectionTitle("Тайлбар"),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Дэлгэрэнгүй мэдээлэл оруулна уу",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onChanged: (value) {
                        bloc.add(SaveAdditionalInfoEvent(state.address ?? "", value));
                      },
                    ),
                    SizedBox(height: 24),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("Огноо ба цаг: ${state.selectedDateTime}");
                          print("Эхлэх цэг: ${state.sourceAddress}");
                          print("Төгсөх цэг: ${state.destinationAddress}");
                          print("Хаяг: ${state.address}");
                          print("Тайлбар: ${state.description}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text("Хадгалах", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildInputField(String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        hintText,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    );
  }
}
