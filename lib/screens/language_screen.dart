import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/providers/lang_provider.dart';
import 'package:project_management_muhmad_omar/widgets/language_widget.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const String id = "/LanguagePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<LangProvider>(
          builder: (context, localizationProvider, child) {
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                widthFactor: 120,
                                child: Image.asset("assets/images/logo.png"),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(AppConstants.select_language_key),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                ),
                                itemCount:
                                    localizationProvider.languages.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => LanguageWidget(
                                  languageModel:
                                      localizationProvider.languages[index],
                                  index: index,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
