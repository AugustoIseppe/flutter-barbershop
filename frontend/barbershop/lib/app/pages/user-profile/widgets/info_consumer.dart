import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/pages/user-profile/user_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InfoConsumer extends StatelessWidget {
  const InfoConsumer({
    super.key,
    required this.colorsPalletes,
    required this.auth,
  });

  final ColorsPalletes colorsPalletes;
  final Auth auth;

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
            Container(
              decoration: BoxDecoration(
                color: colorsPalletes.secondaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, top: 10, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          colorsPalletes.primaryColor,
                      child: Icon(
                        Icons.phone,
                        color: colorsPalletes.nonaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //!------------------------------------------------
                      auth.userData['phone']
                          ,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorsPalletes.white,
                        ),
                      ),
                    ),
                    // Icon(Icons.edit, color: colorsPalletes.nonaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: colorsPalletes.secondaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, top: 10, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          colorsPalletes.primaryColor,
                      child: Icon(
                        Icons.phone,
                        color: colorsPalletes.nonaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //!------------------------------------------------
                      auth.userData['email'],
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorsPalletes.white,
                        ),
                      ),
                    ),
                    // Icon(Icons.edit, color: colorsPalletes.nonaryColor),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
