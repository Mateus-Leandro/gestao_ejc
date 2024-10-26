import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_call_email_app.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FunctionCallUrl functionCallUrl = getIt<FunctionCallUrl>();
    final FunctionCallEmailApp functionCallEmailApp = getIt<FunctionCallEmailApp>();
    const String emailSuporte = "suporteejcsistema@gmail.com";

    return ModelScreen(
      title: 'Gestão EJC',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Olá ${FirebaseAuth.instance.currentUser?.displayName ?? 'usuário'}! Você está utilizando o Gestão EJC.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          Spacer(),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "* Para navegação no sistema utilize a barra lateral",
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "* Em caso de dúvidas, entre em contato com o suporte",
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            "Suporte",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
          ),
          const Divider(),
          Center(
            child: Row(
              children: [
                Tooltip(
                  message: emailSuporte,
                  child: IconButton(
                    onPressed: () {
                      functionCallEmailApp.open(email: emailSuporte);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined, color: Colors.white),
                  ),
                ),
                Tooltip(
                  message: "Cassemiro - 31 99895-4487",
                  child: IconButton(
                    onPressed: () {
                      functionCallUrl.callUrl("https://wa.me/553198954487");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.phone, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      indexMenuSelected: null,
    );
  }
}
