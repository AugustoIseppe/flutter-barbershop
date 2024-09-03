import 'dart:io';

import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/pages/user-profile/user_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotoAndName extends StatefulWidget {
  const PhotoAndName({
    super.key,
    required this.auth,
    required this.colorsPalletes,
  });

  final Auth auth;
  final ColorsPalletes colorsPalletes;

  @override
  State<PhotoAndName> createState() => _PhotoAndNameState();
}

class _PhotoAndNameState extends State<PhotoAndName> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        if (userStore.isLoading) {
          return const CircularProgressIndicator();
        }
        if (userStore.error.isNotEmpty) {
          return Text(userStore.error);
        }
        return Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                _selectedImage != null
                    ? InkWell(
                        // onTap: _pickImage,
                        onTap: () async {},
                        child: CircleAvatar(
                          radius: 125,
                          child: CircleAvatar(
                            radius: 123,
                            backgroundImage: FileImage(_selectedImage!),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {},
                        child: SizedBox(
                          child: CircleAvatar(
                            radius: 126,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 123,
                              backgroundImage: NetworkImage(
                                  "http://10.0.2.2:8800/users/uploads/${widget.auth.userData["image"]}"),
                            ),
                          ),
                        ),
                      ),
                // Exibe o CircularProgressIndicator quando está carregando
                if (_isLoading)
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            widget.colorsPalletes.primaryColor),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 10,
                  right: 30,
                  child: GestureDetector(
                    onTap: () async {
                      await _pickImage();
                      final id = widget.auth.userData['id'];
        
        
                      //Chama o método getUsers da UserStore para atualizar os dados
                      await userStore.getUsersforImage(
                        id,
                        _selectedImage,
                      );
                      // print("&*&*&*&*&*&*&&*&&*naosei: ${naosei["imageUrl"]}");
        
                      // Após a atualização, você pode também atualizar os dados armazenados no Auth (opcional)
                      await widget.auth.tryAutoLogin(); // Isso reatualiza os dados do usuário no Auth
        
                      // Redesenha a tela para refletir os novos dados
                      setState(() {});
        
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: widget.colorsPalletes.tertiaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: widget.colorsPalletes.nonaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 20),
            //NetworkImage("http://192.168.1.109:8800/users/uploads/${widget.auth.userData["imageUrl"]}"),
            Text(
              widget.auth.userData['name'],
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: widget.colorsPalletes.white,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
