import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewApplicationScreen extends StatelessWidget {
  const NewApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppPalette.blueColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
            backgroundColor: AppPalette.blueColor,
            elevation: 0,
            title: Text(
              'New Application',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            centerTitle: false,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              return Center(
                child: Container(
                  width: screenWidth * 0.87,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppPalette.whiteColor.withAlpha((0.98 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.blackColor.withAlpha((0.06 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create New Application',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        ConstantWidgets.hight20(context),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ConstantWidgets.hight20(context),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ConstantWidgets.hight20(context),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppPalette.orengeColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            ConstantWidgets.width20(context),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppPalette.blueColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Application created')),
                                  );
                                },
                                child: Text(
                                  'Create',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
